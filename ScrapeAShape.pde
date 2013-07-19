import android.view.MotionEvent;

ArrayList<TouchDial> diallist;

void setup() {
  size(displayWidth, displayHeight);
  orientation(LANDSCAPE);
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
      thisdial.moveX = event.getX(index);
      thisdial.moveY = event.getY(index);
    }
  }
  
  return super.surfaceTouchEvent(event);
}

