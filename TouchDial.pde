//We need to define a dial type object

class TouchDial {
  private int id;
  private float posX;
  private float posY;
  private float radial;
  
  TouchDial(float id_, posX_, posY_) {
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
  }
}
