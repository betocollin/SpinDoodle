//We need to define a dial type object

class TouchDial {
  private int id;
  private float posX;
  private float posY;
  float moveX;
  float moveY;
  private float radial;
  
  TouchDial(int id_, float posX_, float posY_) {
    id = id_;
    posX = posX_;
    posY = posY_;
    radial = 0;
  }
  
  void setRadial(float radial_) {
    radial = radial_;
  }
  
  void draw() {
  //draw the TouchDial at x,y
    fill(150, 100, 150);
    ellipse(posX, posY, 170, 170);
    line(posX, posY, moveX, moveY);  
  }
}
