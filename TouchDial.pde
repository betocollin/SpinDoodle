//We need to define a dial type object

class TouchDial {
  private int id;
  private float x;
  private float y;
  private float dial;
  //float pdial;
  
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
    dial = dial_;
  }
  
  float getDial() {
    return dial;
  }
  
  /*
  float getDiff() {
    float diff = dial - pdial;
    if (diff < -PI) {
      return diff + 2*PI;
    }
    else if (diff > PI) {
      return diff - 2*PI;
    }
    else {
      return diff;
    }
  }
    */
  
  void draw() {
  //draw the TouchDial at x,y
    noStroke();
    fill(0, 0, 0, 50);
    pushMatrix();
    translate(x, y);
    ellipse(0, 0, 170, 170);
    if (dial > 0) {
      rotate(dial);
      strokeWeight(10);
      stroke(200,0,0);
      arc(0,0, 170, 170, -PI/2-PI/6, -PI/2+PI/6);
      //line(0, 0, 0, -170/2);
    }
    popMatrix();
  }
}
