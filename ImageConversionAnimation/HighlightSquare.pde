class HighlightSquare {
  
  PVector position;
  
  float size;
  
  PVector minPos;
  PVector maxPos;
  
  int ax = 0;
  int ay = 0;
  
  HighlightSquare(float size, int startX, int startY, int maxX, int maxY) {
    this.size = size;
    
    this.minPos = new PVector(startX, startY);
    this.maxPos = new PVector(maxX, maxY);
    
    this.position = this.minPos.copy();
  }
  
  void update() {
    this.position.x += this.size;
    
    if (this.position.x >= this.maxPos.x) {
      this.position.x = this.minPos.x;
      this.position.y += this.size;
    }
  }
  
  void applyStyle() {
    rectMode(CENTER);
    
    noFill();
    stroke(35, 50, 255);
    strokeWeight(2);
  }
  
  void show() {
    push();
    
    this.applyStyle();
    square(this.position.x, this.position.y + this.size / 2, this.size);
    
    pop();
  }
  
}
