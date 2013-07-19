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

  for (int i = 0; i<dialactive.length; i++) {
    if (dialactive[i]) {
      fill(150, 100, 150);
      ellipse(dialx[i], dialy[i], 170, 170);
      line(dialx[i], dialy[i], movex[i], movey[i]);
    }
  }
}

//-----------------------------------------------------------------------------------------

public boolean surfaceTouchEvent(MotionEvent event) {

  // ACTION_DOWN should use MotionDetect.ACTION_DOWN?
  //use findPointerIndex?
  //merge with ACTION_POINTER_DOWN
  if (event.getActionMasked() == MotionEvent.ACTION_DOWN ||
    event.getActionMasked() == MotionEvent.ACTION_POINTER_DOWN) {
      //create a new dial with X and Y coords
    int index = event.getActionIndex();
    //print("Index is " + str(index));
    dialactive[index] = true;
    dialx[index] = event.getX(index);
    dialy[index] = event.getY(index);
    print("(ACTION_DOWN): " +str(index));
  } 
  // ACTION_UP 
  else if (event.getActionMasked() == MotionEvent.ACTION_UP ||
    event.getActionMasked() == MotionEvent.ACTION_POINTER_UP) {
      //destroy the dial
    int index = event.getActionIndex();
    print("Index is " + str(index));
    dialactive[index] = false;
    print("(ACTION_UP): " +str(index));
  }

  //ACTION_MOVE
  else if (event.getActionMasked() == MotionEvent.ACTION_MOVE) {
    //update the dial's 
    int pointercount = event.getPointerCount();
    print("pointercount: " + str(pointercount));
    for (int i = 0; i<pointercount; i++) {
      int pointerId = event.getPointerId(i);
      print("i: " + str(i));
      print("pointerid: " + str(pointerId));
      movex[pointerId] = event.getX(pointerId);
      movey[pointerId] = event.getY(pointerId);
      print("Done movin'!");
    }
  }

  // If you want the variables for motionX/motionY, mouseX/mouseY etc.
  // to work properly, you'll need to call super.surfaceTouchEvent().
  return super.surfaceTouchEvent(event);
}

