//SpinDoodle
import android.view.MotionEvent;

ArrayList<TouchDial> diallist;
PGraphics img;

//The position of the drawing cursor
float [] pcurs = new float[2];
float [] curs = new float[2];

//Values for border drawing
float [] upperedge = new float[2];
float [] loweredge = new float[2];
float border;

Accelerometer accel;
float accelx;
float accely;
float accelz;
float eraserx;
float erasery;

void setup() {
  orientation(PORTRAIT);
  curs[0] = pcurs[0] = displayWidth/2;
  curs[1] = pcurs[1] = displayHeight/2;
  border = 30;
  loweredge[0] = border;
  loweredge[1] = border;
  upperedge[0] = displayWidth-border;
  upperedge[1] = displayHeight-border;

  img = createGraphics(displayWidth, displayHeight);  // Make a PImage object
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    float rand = random(100, 200);
    color c = color(rand);
    img.pixels[i] = c;
  }
  img.updatePixels();
  img.beginDraw();
  img.fill(196, 0, 13);
  img.noStroke();
  img.rect(0, 0, border, img.height);
  img.rect(0, 0, img.width, border);
  img.rect(img.width-border, 0, border, img.height);
  img.rect(0, img.height-border, img.width, border);
  img.endDraw();
  diallist = new ArrayList<TouchDial>();
  accel = new Accelerometer();
}

//-----------------------------------------------------------------------------------------

void draw() {
  image(img, 0, 0);
  for (int i = 0; i<diallist.size(); i++) {
    diallist.get(i).draw();
    float newcurs = curs[i] + 5*diallist.get(i).getDiff();
    if (newcurs > loweredge[i] && newcurs < upperedge[i]) {
      curs[i] = newcurs;
    }
    diallist.get(i).pradial = diallist.get(i).radial;
  }

  //draw on the image not the screen itself.
  img.beginDraw();
  img.stroke(0);
  img.strokeWeight(5);
  img.point(curs[0], curs[1]);
  img.endDraw();

  //handle accelerometer wipe
  accelx = accel.getX();
  if (accelx < 0) {
    accelx = -accelx;
  } 
  accely = accel.getY();
  if (accely < 0) {
    accely = -accely;
  } 
  accelz = accel.getZ();
  if (accelz < 0) {
    accelz = -accelz;
  }
  
  //detect shake
  if (accelx+accely+accelz > 20) {
    //fill a random area with noise
    int erasersize = 300;
    eraserx = random(border,img.width-border-erasersize);
    erasery = random(border, img.height-border-erasersize);

    img.beginDraw();
    for (float i=eraserx; i<eraserx+erasersize; i++) {
      for (float j=erasery; j<erasery+erasersize; j++) {
        img.stroke(random(100,200));
        img.point(i, j);
      }
    }
    img.endDraw();
  }
}
//-----------------------------------------------------------------------------------------

public boolean surfaceTouchEvent(MotionEvent event) {

  if (event.getActionMasked() == MotionEvent.ACTION_DOWN ||
    event.getActionMasked() == MotionEvent.ACTION_POINTER_DOWN) {
    //create a new dial with X and Y coords
    //we only want two touchdials for this app.
    if (diallist.size() < 2) {
      int index = event.getActionIndex();
      TouchDial t = new TouchDial(event.getPointerId(index), event.getX(index), event.getY(index));
      diallist.add(t);
    }
  } 
  else if (event.getActionMasked() == MotionEvent.ACTION_UP ||
    event.getActionMasked() == MotionEvent.ACTION_POINTER_UP) {
    //destroy the dial
    int id = event.getPointerId(event.getActionIndex());
    for (int i=0; i<diallist.size(); i++) {
      if (diallist.get(i).id == id) {
        diallist.remove(i);
      }
    }
  }
  else if (event.getActionMasked() == MotionEvent.ACTION_MOVE) {
    //update the dial's 
    for (int i = 0; i<diallist.size(); i++) {
      TouchDial thisdial = diallist.get(i);
      int index = event.findPointerIndex(thisdial.id);
      float diffx = event.getX(index)-thisdial.getX();
      float diffy = thisdial.getY()-event.getY(index);
      float radial;
      if ((diffy < 0) && (diffx>0)) {
        radial = atan(-diffy/diffx)+PI/2;
      }
      else if ((diffy < 0) && (diffx<0)) {
        radial = atan(diffx/diffy)+PI;
      }
      else if ((diffy>0) && ( diffx<0)) {
        radial = atan(diffy/-diffx)+3*PI/2;
      }
      else {
        radial = atan(diffx/diffy);
      }
      thisdial.setRadial(radial);
    }
  }

  return super.surfaceTouchEvent(event);
}

//returns the angle between two vectors a and b
//scalar product is a(dot)b = |a||b|cos(theta)
public float vector_angle (float ax, float ay, float bx, float by) {

  float adotb = ax*ay+bx*by;
  float moda = sqrt(ax*ax+ay*ay);
  float modb = sqrt(bx*bx+by*by);
  return adotb / moda*modb;
}

