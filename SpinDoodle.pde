//SpinDoodle

import android.view.MotionEvent;

ArrayList<TouchDial> diallist;
PGraphics canvas;
PGraphics doodle;

//The position of the drawing cursor
float [] curs = new float[2];
float [] pcurs = new float[2];

//dial values
float [] dial = new float[2];
float [] pdial = new float[2];

//Values for border drawing
float [] upperedge = new float[2];
float [] loweredge = new float[2];
float border;
float bezel;

Accelerometer accel;
float accelx;
float accely;
float accelz;

void setup() {
  orientation(PORTRAIT);
  curs[0] = pcurs[0] = displayWidth/2;
  curs[1] = pcurs[1] = displayHeight/2;
  border = 30;
  bezel = 5;

  loweredge[0] = border;
  loweredge[1] = border;
  upperedge[0] = displayWidth-border;
  upperedge[1] = displayHeight-border;
  canvas = createGraphics(displayWidth, displayHeight);  // Make an object for the canvas
  doodle = createGraphics(displayWidth, displayHeight);  // Make an object for the doodling
  diallist = new ArrayList<TouchDial>();
  accel = new Accelerometer();
  clear_canvas();
  //clear_doodle();
}

//we cant make the fuzz area transparent because we are drawing 
//on the main screen with the controls
//therefore as the fuzz image becomes more transparent it will reveal the 
//controls that were drawn earlier.
//we need a doodle image that is made transparent. revealing the canvas underneath.

void fade_doodle() {
  float r, g ,b, a;
  color pix;
  //generate textured area
  //manipulating the pixels directly is clunky but 1,000 times faster.
  doodle.loadPixels();
  for (int i = 0; i < doodle.pixels.length; i++) {
    pix = doodle.pixels[i];
    r = red(pix);
    g = green(pix);
    b = blue(pix);
    a = alpha(pix);
    pix = color(r, g, b, constrain(a-50, 0, 255));
    doodle.pixels[i] = pix;
  }
  doodle.updatePixels();
}

void clear_canvas() {
  //generate textured area
  //manipulating the pixels directly is clunky but 1,000 times faster.
  canvas.loadPixels();
  for (int i = 0; i < canvas.pixels.length; i++) {
    float rand = random(125, 175);
    color c = color(rand);
    canvas.pixels[i] = c;
  }
  canvas.updatePixels();

  //draw the border
  canvas.beginDraw();
  canvas.noStroke();

  //black corners
  canvas.fill(0);
  canvas.rect(0, 0, border, border);
  canvas.rect(canvas.width-border, 0, border, border);
  canvas.rect(0, canvas.height-border, border, border);
  canvas.rect(canvas.width-border, canvas.height-border, border, border);

  //red borders
  canvas.fill(196, 0, 13);
  canvas.rect(0, border, border, canvas.height-border*2); //left bar
  canvas.rect(border, 0, canvas.width-border*2, border); //top bar
  canvas.rect(canvas.width-border, border, border, canvas.height-border*2); //right bar
  canvas.rect(border, canvas.height-border, canvas.width-border*2, border); //bottom bar

    //curve corners
  canvas.arc(border, border, border*2, border*2, PI, PI+HALF_PI);
  canvas.arc(canvas.width-border, border, border*2, border*2, PI+HALF_PI, TWO_PI);
  canvas.arc(border, canvas.height-border, border*2, border*2, HALF_PI, PI);
  canvas.arc(canvas.width-border, canvas.height-border, border*2, border*2, 0, HALF_PI);

  //an inside edge effect
  canvas.fill(122, 5, 13);
  canvas.noStroke();
  canvas.rect(border-bezel, border-bezel, bezel, canvas.height-2*border+2*bezel);
  canvas.rect(border, border-bezel, canvas.width-2*border, bezel);
  canvas.fill(219, 107, 155);
  canvas.rect(canvas.width-border, border-bezel, bezel, canvas.height-2*border+2*bezel);
  canvas.rect(border, canvas.height-border, canvas.width-2*border, bezel);
  canvas.endDraw();
}

//-----------------------------------------------------------------------------------------

void draw() {
  float diff;
  float newcurs;
  TouchDial dial;
  
  //put the doodle on screen
  image(canvas, 0, 0);
  
  //calculate the cursor position based in the dials
  if (!diallist.isEmpty()) {
    for (int i = 0; i<diallist.size(); i++) {
      try {
        dial = diallist.get(i);
      } catch (IndexOutOfBoundsException e) {
        continue;
      }
      dial.draw();
      newcurs = curs[i] + 5*dial.getDelta(); //5 is a fudge factor
      
      if ((newcurs > loweredge[i]) && (newcurs < upperedge[i])) {
        curs[i] = newcurs;
      }
    }
  }

  //draw on the doodle graphic (not the screen itself)
  doodle.beginDraw();
  doodle.stroke(0);
  doodle.strokeWeight(5);
  doodle.point(curs[0], curs[1]);
  doodle.endDraw();
  image(doodle, 0, 0);

  //draw a marker on skreen to show actual position of cursor 
  stroke(255);
  strokeWeight(2);
  point(curs[0], curs[1]);  

  //handle accelerometer wipe
  accelx = accel.getX();
  accely = accel.getY();
  accelz = accel.getZ();

  //clear screen on shake
  if ((abs(accelx)+abs(accely)+abs(accelz)) > 30) {
    fade_doodle();
  }
}
//-----------------------------------------------------------------------------------------

public boolean surfaceTouchEvent(MotionEvent event) {
TouchDial dial;

  if ((event.getActionMasked() == MotionEvent.ACTION_DOWN) ||
    (event.getActionMasked() == MotionEvent.ACTION_POINTER_DOWN)) {
    //create a new dial with X and Y coords
    //we only want two touchdials for this app.
    if (diallist.size() < 2) {
      int index = event.getActionIndex();
      dial = new TouchDial(event.getPointerId(index), event.getX(index), event.getY(index));
      diallist.add(dial);
    }
  }
  else if ((event.getActionMasked() == MotionEvent.ACTION_UP) ||
    (event.getActionMasked() == MotionEvent.ACTION_POINTER_UP)) {
    //destroy the dial
    int id = event.getPointerId(event.getActionIndex());
    if (!diallist.isEmpty()) {
      for (int i=diallist.size()-1; i>=0; i--) {
        try {
          dial = diallist.get(i);
        } catch (IndexOutOfBoundsException e) {
          continue;
        }
        if (dial.id == id) {
          diallist.remove(i);
          break;
        }
      }
    }
  }
  else if (event.getActionMasked() == MotionEvent.ACTION_MOVE) {
    //update the dials
    if (!diallist.isEmpty()) {
      for (int i = 0; i<diallist.size(); i++) {
        try {
          dial = diallist.get(i);
        } catch (IndexOutOfBoundsException e) {
          continue;
        }
        int index = event.findPointerIndex(dial.id);
        float x = event.getX(index)-dial.getX();
        float y = dial.getY()-event.getY(index);

        if ((y < 0) && (x>0)) {
          dial.setDial(atan(-y/x)+PI/2);
        }
        else if ((y < 0) && (x<0)) {
          dial.setDial(atan(x/y)+PI);
        }
        else if ((y>0) && ( x<0)) {
          dial.setDial(atan(y/-x)+3*PI/2);
        }
        else if ((y != 0) && (x!=0)) {
          dial.setDial(atan(x/y));
        }
      }
    }
  }

  return super.surfaceTouchEvent(event);
}

