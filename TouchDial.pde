//We need to define a dial type object

class TouchDial {
  private int id;
  private float x;
  private float y;
  private float dial;
  private float delta;
  
  TouchDial(int id_, float x_, float y_) {
    id = id_;
    x = x_;
    y = y_;
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
    ellipse(0, 0, 170, 170);
    if (dial > -1) {
      rotate(dial);
      strokeWeight(10);
      stroke(196, 0, 13);
      arc(0,0, 170, 170, -PI/2-PI/6, -PI/2+PI/6);
      //line(0, 0, 0, -170/2);
    }
    popMatrix();
  }
}
