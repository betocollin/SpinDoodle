//We need to define a dial type object

class TouchDial {
  private int id;
  private float posX;
  private float posY;
  float radial;
  
  TouchDial(int id_, float posX_, float posY_) {
    id = id_;
    posX = posX_;
    posY = posY_;
    radial = -1;
  }
  
  float getX(){
    return posX;
  }
  
  float getY(){
    return posY;
  }
  
  void setRadial(float radial_) {
    radial = radial_;
  }
  
  void draw() {
  //draw the TouchDial at x,y
    noStroke();
    fill(0, 0, 0, 50);
    pushMatrix();
    translate(posX, posY);
    ellipse(0, 0, 170, 170);
    if (radial > 0) {
      rotate(radial);
      strokeWeight(10);
      stroke(200,0,0);
      arc(0,0, 170, 170, -PI/2-PI/6, -PI/2+PI/6);
      //line(0, 0, 0, -170/2);
    }
    popMatrix();
  }
}
