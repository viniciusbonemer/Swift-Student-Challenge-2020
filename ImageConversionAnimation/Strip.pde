int strip_width = 1;
int strip_height = 16;

color HIGHLIGHT_COLOR = color(35, 50, 255);
float HIGHLIGHT_MULT_W = 2;
float HIGHLIGHT_MULT_H = 1.5;

class Strip {
  
  PVector pos;
  int w;
  int h;
  color col;
  
  Strip(int centerX, int centerY, color col) {
    this.pos = new PVector(centerX, centerY);
    this.w = strip_width;
    this.h = strip_height;
    
    this.col = col;
  }
  
  void applyStyle() {
    noStroke();
    rectMode(CENTER);
    fill(this.col);
  }
  
  void show() {
    push();
    
    this.applyStyle();
    rect(this.pos.x, this.pos.y, this.w, this.h);
    
    pop();
  }
  
  void showHighlighted() {
    push();
    
    this.applyStyle();
    fill(HIGHLIGHT_COLOR);
    stroke(HIGHLIGHT_COLOR);
    rect(this.pos.x, this.pos.y, this.w * HIGHLIGHT_MULT_W, this.h * HIGHLIGHT_MULT_H);
    
    pop();
  }
  
}
