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

class TouchDial {
  private int id;
  private float x;
  private float y;
  private float dial;
  private float delta;
  private color colour;
  
  TouchDial(int id_, float x_, float y_, color c_) {
    id = id_;
    x = x_;
    y = y_;
    colour = c_;
    dial = -1;
  }
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  void setDial(float dial_) {
      if ((dial >=PI+HALF_PI) && (dial_ <= HALF_PI)) {
        delta = TWO_PI - dial + dial_;
      }
      else if ((dial <= HALF_PI) && (dial_ >=PI+HALF_PI)) {
        delta = dial_-TWO_PI-dial;
      }
      else if (dial == -1) {
        delta = 0;
      }
      else {
        delta = dial_ - dial;
      }    
    dial = dial_;
  }
  
  float getDial() {
    return dial;
  }
  
  float getDelta() {
    return delta;
  }
  
  void draw() {
  //draw the TouchDial at x,y
    noStroke();
    fill(0, 0, 0, 50);
    pushMatrix();
    translate(x, y);
    stroke(255);
    strokeWeight(2);
    if (id == 0) {
      line(-170/2, 0, 170/2, 0);
    }
    else {
      line(0, -170/2, 0, 170/2);
    }
    noStroke();
    ellipse(0, 0, 170, 170);
    if (dial > -1) {
      rotate(dial);
      stroke(colour);
      strokeWeight(10);
      arc(0,0, 170, 170, -PI/2-PI/6, -PI/2+PI/6);
    }
    popMatrix();
  }
}
