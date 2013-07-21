import android.view.MotionEvent;

ArrayList<TouchDial> diallist;

void setup() {
  background(0, 255, 0);
  fill(0, 0, 244);
  rect(100, 100, 100, 100);
  stroke(255);
  diallist = new ArrayList<TouchDial>();

}

//-----------------------------------------------------------------------------------------

void draw() {
  background(255, 0, 0);

  for (int i = 0; i<diallist.size(); i++) {
    diallist.get(i).draw();
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
      thisdial.radial = radial;
      thisdial.moveX = event.getX(index);
      thisdial.moveY = event.getY(index);
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
