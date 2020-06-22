
class Pixelator {
  
  PVector center;
  int size;
  
  PImage logo;
  PImage destination;
  int step = 25;
  
  int px = 0;
  int py = 0;
  
  boolean finished = false;
  
  HighlightSquare highlightSquare;
  
  Pixelator(String imageName, int centerX, int centerY, int size) {
    this.center = new PVector(centerX, centerY);
    this.size = size;
    
    this.logo = loadImage(imageName);
    this.destination = createImage(logo.width, logo.height, RGB);
    
    int hs_x = int(this.center.x - this.size/2);
    int hs_y = int(this.center.y - this.size/2);
    this.highlightSquare = new HighlightSquare(this.getScale() * this.step, hs_x, hs_y, hs_x + this.size, hs_y + this.size);
    
    this.prepareDestination();
  }
  
  void prepareDestination() {
    color clearColor = color(255, 255, 255, 0);
    this.destination.loadPixels();
    
    for (int i = 0; i < destination.pixels.length; ++i) {
      this.destination.pixels[i] = clearColor;
    }
    
    this.destination.updatePixels();
  }
  
  float getScale() {
    return float(this.size) / this.logo.width;
  }
  
  int getFinalPixelCount() {
    return ceil(float(this.destination.pixels.length) / (this.step * this.step));
  }
  
  // Returns the average color in the region
  color pixelate(int x, int y) {
    int arr_size = step*step;
    int[] pix_indexes = new int[arr_size];
    int i = 0;
    
    long red_sum = 0;
    long green_sum = 0;
    long blue_sum = 0;
    
    logo.loadPixels();
    destination.loadPixels();
    
    // Iterate through pixels in range
    for (int pixel_j = y; pixel_j < y + step; ++pixel_j) {
      for (int pixel_i = x; pixel_i < x + step; ++pixel_i) {
        int flat_i = pixel_j * logo.width + pixel_i;
        pix_indexes[i++] = flat_i;
        // Sum the colors
        red_sum += red(logo.pixels[flat_i]);
        green_sum += green(logo.pixels[flat_i]);
        blue_sum += blue(logo.pixels[flat_i]);
      }
    }
    
    // Get the average
    int r = int(red_sum / arr_size);
    int g = int(green_sum / arr_size);
    int b = int(blue_sum / arr_size);
    int new_color = color(r, g, b);
    
    // Update every pixel in range
    for (i = 0; i < arr_size; ++i) {
      int pi = pix_indexes[i];
      destination.pixels[pi] = new_color;
    }
    
    destination.updatePixels();
    return new_color;
  }
  
  void update() {
    if (this.finished) return;
    
    this.highlightSquare.update();
    
    color newColor = this.pixelate(this.px, this.py);
    pallete.addStrip(newColor);
    
    this.px += this.step;
    if (this.px >= this.logo.width) {
      this.px = 0;
      this.py += step;
    }
    if (py >= logo.height) {
      this.finished = true;
    }
  }
  
  void applyStyle() {
    rectMode(CENTER);
    imageMode(CENTER);
    
    noFill();
    stroke(0);
    strokeWeight(2);
  }
  
  void show(boolean shouldHighlight) {
    push();
    
    this.applyStyle();
    rect(this.center.x, this.center.y, this.size, this.size);
    image(logo, this.center.x, this.center.y, this.size, this.size);
    image(destination, this.center.x, this.center.y, this.size, this.size);
    
    if (shouldHighlight) {
      this.highlightSquare.show();
    }
    
    pop();
   }
    
}
