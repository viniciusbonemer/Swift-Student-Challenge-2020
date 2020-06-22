color FILL_COLOR = color(255);

int STROKE_WEIGHT = 2;
color STROKE_COLOR = color(0);

class Pallete {
  
  int centerX;
  int centerY;
  int w;
  int h;
  
  int strip_next_x;
  
  boolean shouldShowText = false;
  boolean finishedAddingText = false;
  
  Strip[] strips;
  int strip_i = 0;
  
  Pallete(int centerX, int centerY, int w, int h) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.w = w;
    this.h = h;
    
    this.strip_next_x = this.centerX - this.w/2;
    
    this.strips = new Strip[w];
  }

  void addStrip(color c) {
    Strip strip = new Strip(this.strip_next_x, this.centerY, c);
    strips[strip_i++] = strip;
    strip_next_x += strip.w;
  }
  
  void drawStrips() {
    push();
    
    for (int i = 0; i < strip_i; i++) {
      Strip strip = strips[i];
      strip.show();
    }
    
    pop();
  }
  
  void drawHighlightedStrip() {
    this.drawHighlightedStrip(strip_i - 1);
  }
  
  void drawHighlightedStrip(int index) {
    push();
    
    Strip strip = strips[index];
    strip.showHighlighted();
    
    pop();
  }
  
  void show(boolean shouldHighlight) {
    push();
    
    fill(FILL_COLOR);
    stroke(STROKE_COLOR);
    strokeWeight(STROKE_WEIGHT);
    rectMode(CENTER);
    
    rect(this.centerX, this.centerY, this.w, this.h + STROKE_WEIGHT);
    
    drawStrips();
    if (shouldHighlight) drawHighlightedStrip();
    
    noFill();
    rect(this.centerX, this.centerY, this.w, this.h + STROKE_WEIGHT);
    
    if (this.shouldShowText) {
      this.showText();
    }
    
    pop();
  }
  
  void addToText() {
    if (text.length() > 28 * 30) {
      text = text.substring(28 * 30);
    }
    if (colCharIndex >= binary(color(0)).substring(8).length()) {
      addedColIndex += 2; //1; // TIME
      while(addedColIndex < this.strips.length - 1 && hex(this.strips[addedColIndex].col).equals(hex(this.strips[addedColIndex + 1].col))) addedColIndex += 1;
      colCharIndex = 0;
      text += "\n";
    } else if (colCharIndex % 4 == 0 && colCharIndex != 0) {
      text += " ";
    }
    
    if (addedColIndex >= this.strips.length) {
      this.finishedAddingText = true;
      return;
    }
    
    this.text = this.text + binary(this.strips[addedColIndex].col).substring(8).charAt(colCharIndex++);
  }
  
  int addedColIndex = 0;
  int colCharIndex = 0;
  String text = "";
  
  void showText() {
    push();
    
    translate(width/2, height/2);
    rotate(-HALF_PI);
    translate(-width/2, -height/2);
    
    fill(0);
    float tW = this.centerY - 2.5 * this.h;
    float tH = this.w;
    float tX = height - this.centerY + 1.5 * h;
    float tY = this.centerX - this.w/2;
    rectMode(CORNER);
    text(this.text, tX, tY, tW, tH);
    
    //strokeWeight(5);
    //stroke(255, 0, 0);
    //rect(tX, tY, tW, tH);
    
    pop();
  }
  
}
