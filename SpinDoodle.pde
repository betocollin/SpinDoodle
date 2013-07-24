//SpinDoodle
import android.view.MotionEvent;

ArrayList<TouchDial> diallist;
PGraphics img;

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
  img = createGraphics(displayWidth, displayHeight);  // Make a PImage object
  diallist = new ArrayList<TouchDial>();
  accel = new Accelerometer();
  clear_screen();
}

void clear_screen() {
  //generate textured area
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    float rand = random(125, 175);
    color c = color(rand);
    img.pixels[i] = c;
  }
  img.updatePixels();

  //draw the border
  img.beginDraw();
  img.noStroke();

  //black corners
  img.fill(0);
  img.rect(0, 0, border, border);
  img.rect(img.width-border, 0, border, border);
  img.rect(0, img.height-border, border, border);
  img.rect(img.width-border, img.height-border, border, border);

  //red borders
  img.fill(196, 0, 13);
  img.rect(0, border, border, img.height-border*2); //left bar
  img.rect(border, 0, img.width-border*2, border); //top bar
  img.rect(img.width-border, border, border, img.height-border*2); //right bar
  img.rect(border, img.height-border, img.width-border*2, border); //bottom bar

    //curve corners
  img.arc(border, border, border*2, border*2, PI, PI+HALF_PI);
  img.arc(img.width-border, border, border*2, border*2, PI+HALF_PI, TWO_PI);
  img.arc(border, img.height-border, border*2, border*2, HALF_PI, PI);
  img.arc(img.width-border, img.height-border, border*2, border*2, 0, HALF_PI);

  //an inside edge effect
  img.fill(122, 5, 13);
  img.noStroke();
  img.rect(border-bezel, border-bezel, bezel, img.height-2*border+2*bezel);
  img.rect(border, border-bezel, img.width-2*border, bezel);
  img.fill(219, 107, 155);
  img.rect(img.width-border, border-bezel, bezel, img.height-2*border+2*bezel);
  img.rect(border, img.height-border, img.width-2*border, bezel);
  img.endDraw();
}

//-----------------------------------------------------------------------------------------

void draw() {
  float diff;
  float newcurs;

  //put the doodle on screen
  image(img, 0, 0);

  //calculate the cursor position based in the dials
  if (!diallist.isEmpty()) {
    for (int i = 0; i<diallist.size(); i++) {
      //need to handle exception around get in case the item is deleted.
      diallist.get(i).draw();
      newcurs = curs[i] + 5*diallist.get(i).getDelta(); //5 is a fudge factor
      if ((newcurs > loweredge[i]) && (newcurs < upperedge[i])) {
        curs[i] = newcurs;
      }
    }
  }

  //draw on the image (not the screen itself)
  img.beginDraw();
  img.stroke(0);
  img.strokeWeight(5);
  img.point(curs[0], curs[1]);
  img.endDraw();

  //handle accelerometer wipe
  accelx = accel.getX();
  accely = accel.getY();
  accelz = accel.getZ();

  //clear screen on shake
  if ((abs(accelx)+abs(accely)+abs(accelz)) > 30) {
    clear_screen();
  }
}
//-----------------------------------------------------------------------------------------

public boolean surfaceTouchEvent(MotionEvent event) {

  if ((event.getActionMasked() == MotionEvent.ACTION_DOWN) ||
    (event.getActionMasked() == MotionEvent.ACTION_POINTER_DOWN)) {
    //create a new dial with X and Y coords
    //we only want two touchdials for this app.
    if (diallist.size() < 2) {
      int index = event.getActionIndex();
      TouchDial t = new TouchDial(event.getPointerId(index), event.getX(index), event.getY(index));
      diallist.add(t);
    }
  } 
  else if ((event.getActionMasked() == MotionEvent.ACTION_UP) ||
    (event.getActionMasked() == MotionEvent.ACTION_POINTER_UP)) {
    //destroy the dial
    int id = event.getPointerId(event.getActionIndex());
    if (!diallist.isEmpty()) {
      for (int i=diallist.size()-1; i>=0; i--) {
        if (diallist.get(i).id == id) {
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
        TouchDial thisdial = diallist.get(i);
        int index = event.findPointerIndex(thisdial.id);
        float x = event.getX(index)-thisdial.getX();
        float y = thisdial.getY()-event.getY(index);

        if ((y < 0) && (x>0)) {
          thisdial.setDial(atan(-y/x)+PI/2);
        }
        else if ((y < 0) && (x<0)) {
          thisdial.setDial(atan(x/y)+PI);
          println("setting radial to :" + str(thisdial.getDial()));
        }
        else if ((y>0) && ( x<0)) {
          thisdial.setDial(atan(y/-x)+3*PI/2);
          println("setting radial to :" + str(thisdial.getDial()));
        }
        else if ((y != 0) && (x!=0)) {
          thisdial.setDial(atan(x/y));
          println("setting radial to :" + str(thisdial.getDial()));
        }
        else {
          println("Doing nothing (" + str(x) + "," + str(y) + ")!!!");
        }
      }
    }
  }

  return super.surfaceTouchEvent(event);
}

