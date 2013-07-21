//SpinDoodle
import android.view.MotionEvent;

ArrayList<TouchDial> diallist;
PGraphics img;
int brushsize;
float [] pcurs = new float[2];
float [] curs = new float[2];
float [] limits = new float[2];

void setup() {
  orientation(PORTRAIT);
  curs[0] = pcurs[0] = displayWidth/2;
  curs[1] = pcurs[1] = displayHeight/2;
  limits[0] = displayWidth;
  limits[1] = displayHeight;
  brushsize = 15;
  
  img = createGraphics(displayWidth, displayHeight);  // Make a PImage object
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    float rand = random(255);
    color c = color(rand);
    img.pixels[i] = c;
  }
  img.updatePixels();
  fill(0, 0, 244);
  stroke(0);
  diallist = new ArrayList<TouchDial>();
}

//-----------------------------------------------------------------------------------------

void draw() {
  image(img,0,0);
  for (int i = 0; i<diallist.size(); i++) {
    diallist.get(i).draw();
    float newcurs = curs[i] + 5*diallist.get(i).getDiff();
    if (newcurs > 0 && newcurs < limits[i]) {
      curs[i] = newcurs;
    }
    diallist.get(i).pradial = diallist.get(i).radial;
  }
  
  //draw on the image not the screen itself.
  img.beginDraw();
  img.strokeWeight(5);
  println("Coords: (" + str(curs[0]) + "," + str(curs[1]) + ") = Pixel " + str(int(curs[0])+img.width*int(curs[1])));
  img.point(curs[0], curs[1]);
  img.endDraw();
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

