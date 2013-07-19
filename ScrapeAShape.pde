/*
 *
 * androidMultiTouch.pde
 * Shows the basic use of MultiTouch Events
 *
 */

//-----------------------------------------------------------------------------------------
// IMPORTS

import android.view.MotionEvent;


//-----------------------------------------------------------------------------------------
// VARIABLES

/* A touch point is left on the screen because the array containing x and y coords is not 
 expected to change. x[0] always refers to the first object. x[1] to the second.
 
 However, if a pointer is removed from the event list then other pointers may have their index
 changed. the event list is like a dynamic list. Therefore we need to mirror this behaviour
 in our code.
 */

ArrayList<TouchDial> diallist;

boolean dialactive[] = new boolean[2];
 float dialx[] = new float[2];
 float dialy[] = new float[2];
 float movex[] = new float[2];
 float movey[] = new float[2];
//-----------------------------------------------------------------------------------------

void setup() {
  size(displayWidth, displayHeight);
  orientation(LANDSCAPE);
  background(0, 255, 0);
  fill(0, 0, 244);
  rect(100, 100, 100, 100);
  stroke(255);
  diallist = new ArrayList<TouchDial>();

  dialactive[0] = false;
  dialactive[1] = false;
  dialx[0] = 0;
  dialx[1] = 0;
  dialy[0] = 0;
  dialy[1] = 0;
  movex[0] = 0;
  movex[1] = 0;
  movey[0] = 0;
  movey[1] = 0;
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

  //use findPointerIndex?
  //merge with ACTION_POINTER_DOWN
  if (event.getActionMasked() == MotionEvent.ACTION_DOWN ||
    event.getActionMasked() == MotionEvent.ACTION_POINTER_DOWN) {
    print("(ACTION_DOWN)");
    //create a new dial with X and Y coords
    //we only want two touchdials for this app.
    if (diallist.size() < 2) {
      int index = event.getActionIndex();
      TouchDial t = new TouchDial(event.getPointerId(index), event.getX(index), event.getY(index));
      diallist.add(t);
    }
  } 
  // ACTION_UP 
  else if (event.getActionMasked() == MotionEvent.ACTION_UP ||
    event.getActionMasked() == MotionEvent.ACTION_POINTER_UP) {
    print("(ACTION_UP)");
    //destroy the dial
    int index = event.getActionIndex();
    int id = event.getPointerId(index);
    //ur here: find and remove every entry in array list with matching pointer id
    for (int i=0; i<diallist.size(); i++) {
      if (diallist.get(i).id == id) {
        diallist.remove(i);
      }
    }
  }

  //ACTION_MOVE
  else if (event.getActionMasked() == MotionEvent.ACTION_MOVE) {
    print("(ACTION_MOVE)");
    //getX takes an index
    //count over the diallist
    //for each dial use findpointerindex()
    //update the dial with the new values

    //update the dial's 
    int pointercount = event.getPointerCount();
    print("pointercount: " + str(pointercount));
    for (int i = 0; i<diallist.size(); i++) {
      TouchDial thisdial = diallist.get(i);
      int index = event.findPointerIndex(thisdial.id);
      thisdial.moveX = event.getX(index);
      thisdial.moveY = event.getY(index);

      //print("i: " + str(i));
      //print("pointerid: " + str(pointerId));
      //movex[pointerId] = event.getX(i);
      //movey[pointerId] = event.getY(i);
      //print("Done movin'!");
    }
  }

  // If you want the variables for motionX/motionY, mouseX/mouseY etc.
  // to work properly, you'll need to call super.surfaceTouchEvent().
  return super.surfaceTouchEvent(event);
}

