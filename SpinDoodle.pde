/***********************************************************************
    SpinDoodle - An Android application written in Processing/Java

    Copyright (C) 2013 Paul Backhouse

    This file is part of SpinDoodle. SpinDoodle is free software: you
    can redistribute it and/or modify it under the terms of the GNU
    General Public License as published by the Free Software
    Foundation, either version 3 of the License, or (at your option)
    any later version.

    SpinDoodle is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with SpinDoodle.  If not, see <http://www.gnu.org/licenses/>.
***********************************************************************/

import android.view.MotionEvent;

//constants used to render brush
final int brush_speed = 10;
final int brush_weight = 5;

//constants for frame graphics
final float border = 30;
final float bezel = 5;
final float logosize = 120;
final float logooffset = 15;

//constant colours used throughout sketch
final color red_colour = color(127, 0, 0);
final color dark_red_colour = color(70, 0, 0);
final color light_red_colour = color(255, 149, 133);
final color yellow_colour = color(255, 216, 0);

//arraylist to contain dials
ArrayList<TouchDial> diallist = new ArrayList<TouchDial>();

//graphics objects for surface and doodle
PGraphics canvas;
PGraphics doodle;

//The position of the doodle cursor
float [] curs = new float[2];

//dial values
float [] dial = new float[2];
float [] pdial = new float[2];

//Values for border drawing
float [] upperedge = new float[2];
float [] loweredge = new float[2];

//font for logo text
PFont font;

//accelerometer for shake to clear
Accelerometer accel;
float accelx;
float accely;
float accelz;

void setup() {
  //set initial values that cannot be set outside setup()
  orientation(PORTRAIT);
  curs[0] = displayWidth/2;
  curs[1] = displayHeight/2;

  loweredge[0] = border;
  loweredge[1] = border;
  upperedge[0] = displayWidth-border;
  upperedge[1] = displayHeight-logosize;
  font = createFont("tallpaul.ttf", logosize-20, true);
  canvas = createGraphics(displayWidth, displayHeight);  // Make an object for the canvas
  doodle = createGraphics(displayWidth, displayHeight);  // Make an object for the doodling
  accel = new Accelerometer();

  //generate textured doodle canvas
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
  canvas.fill(red_colour);
  canvas.rect(0, loweredge[1], loweredge[0], canvas.height-border*2); //left bar 
  canvas.rect(loweredge[0], 0, upperedge[0]-loweredge[0], loweredge[1]); //top bar
  canvas.rect(upperedge[0], loweredge[1], canvas.width-upperedge[0], canvas.height-border*2); //right bar
  canvas.rect(loweredge[0], upperedge[1], upperedge[0]-loweredge[0], canvas.height-upperedge[1]); //bottom bar

  //curve corners
  canvas.arc(border, border, border*2, border*2, PI, PI+HALF_PI);
  canvas.arc(canvas.width-border, border, border*2, border*2, PI+HALF_PI, TWO_PI);
  canvas.arc(border, canvas.height-border, border*2, border*2, HALF_PI, PI);
  canvas.arc(canvas.width-border, canvas.height-border, border*2, border*2, 0, HALF_PI);

  //an inside edge effect
  canvas.fill(dark_red_colour);
  canvas.noStroke();
  canvas.rect(loweredge[0]-bezel, loweredge[1]-bezel, bezel, upperedge[1]-loweredge[1]+2*bezel); //left
  canvas.rect(loweredge[0], loweredge[1]-bezel, upperedge[0]-loweredge[0], bezel); //top
  canvas.fill(light_red_colour);
  canvas.rect(upperedge[0], loweredge[1]-bezel, bezel, upperedge[1]-loweredge[1]+2*bezel); //right
  canvas.rect(loweredge[0], upperedge[1], upperedge[0]-loweredge[0], bezel);  //bottom
  
  canvas.textFont(font);
  canvas.textAlign(CENTER);
  canvas.fill(0);
  canvas.text("SpinDoodle", displayWidth/2+4, upperedge[1]+(displayHeight-upperedge[1])/2+logooffset+4);
  canvas.fill(yellow_colour);
  canvas.text("SpinDoodle", displayWidth/2, upperedge[1]+(displayHeight-upperedge[1])/2+logooffset);
  canvas.endDraw();
}

void fade_doodle() {
  float r, g ,b, a;
  color pix;
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
      newcurs = curs[i] + brush_speed*constrain(dial.getDelta(), -QUARTER_PI, QUARTER_PI);
      
      if ((newcurs > loweredge[i]+brush_weight/2) && (newcurs < upperedge[i]-brush_weight/2)) {
        curs[i] = newcurs;
      }
    }
  }

  //draw on the doodle graphic (not the screen itself)
  doodle.beginDraw();
  doodle.stroke(0);
  doodle.strokeWeight(brush_weight);
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
  int index;
  int id;
  float x;
  float y;

  if ((event.getActionMasked() == MotionEvent.ACTION_DOWN) ||
    (event.getActionMasked() == MotionEvent.ACTION_POINTER_DOWN)) {
    //create a new dial with X and Y coords
    //we only want two touchdials for this app.
    if (diallist.size() < 2) {
      index = event.getActionIndex();
      dial = new TouchDial(event.getPointerId(index), event.getX(index), event.getY(index), red_colour);
      diallist.add(dial);
    }
  }
  else if ((event.getActionMasked() == MotionEvent.ACTION_UP) ||
    (event.getActionMasked() == MotionEvent.ACTION_POINTER_UP)) {
    //destroy the dial
    id = event.getPointerId(event.getActionIndex());
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
        index = event.findPointerIndex(dial.id);
        x = event.getX(index)-dial.getX();
        y = dial.getY()-event.getY(index);

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

