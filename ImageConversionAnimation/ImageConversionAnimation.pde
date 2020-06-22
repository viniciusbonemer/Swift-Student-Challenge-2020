String LOGO_FILE = "Memoji_1.png";

Pixelator pixelator;
Pallete pallete;

void setup() {
  size(512, 512);//768);

  int pixelatorCenterX = width / 2;
  int pixelatorCenterY = height / 2;
  int pixelatorSize = 200;

  //Load image
  this.pixelator = new Pixelator(LOGO_FILE, pixelatorCenterX, pixelatorCenterY, pixelatorSize);

  int palleteWidth = pixelator.getFinalPixelCount();
  int palleteHeight = 16;
  int pallete_center_y = int(pixelator.center.y + pixelator.size/2 + 50 + palleteHeight/2);
  pallete = new Pallete(width/2, pallete_center_y, palleteWidth, palleteHeight);
}

boolean pixelating = true;

void pixelate() {
  // PIXELATE AND SELECT COLOR
  pixelator.update();

  if (pixelator.finished) {
    pixelating = false;
    fading = true;
    println("Finished pixelating");
  }

  // DRAW IMAGES
  pixelator.show(pixelating);
}

boolean fading = false;
int fadeDur = 60; //90; // TIME
int fadeIndex = 0;

float easeInOutCubic(float t) {
  return t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2;
}

void fade() {
  float pct = map(fadeIndex++, 0, fadeDur, 0, 1);

  if (fadeIndex >= fadeDur) {
    println("Finish fade");
    fading = false;
    turning = true;
    return;
  }

  pct = easeInOutCubic(pct);
  pct = map(pct, 0, 1, 0, 255);
  pixelator.show(false);

  push();
  rectMode(CENTER);
  noStroke();
  fill(255, pct);
  rect(pixelator.center.x, pixelator.center.y, pixelator.size + 5, pixelator.size + 5);
  pop();
}

boolean turning = false;
float maxAng = HALF_PI;
float turnDur = 60; //90; // TIME
int turnIndex = 0;
float turnAngle = 0;

void updateAngle() {
  float pct = map(turnIndex++, 0, turnDur, 0, 1);

  if (turnIndex >= turnDur) {
    println("Finish turn");
    turning = false;
    this.makingBin = true;
    return;
  }

  pct = easeInOutCubic(pct);
  turnAngle = map(pct, 0, 1, 0, maxAng);
}

boolean makingBin = false;

void makeBin() {
  if (pallete.finishedAddingText) {
    this.makingBin = false;
    noLoop();
    return;
  }
  if (!pallete.shouldShowText) pallete.shouldShowText = true;
  for (int i = 0; i < 6; ++i) pallete.addToText();
  if (pallete.addedColIndex < pallete.strips.length) {
    pallete.drawHighlightedStrip(pallete.addedColIndex);
  }
}

void draw() {
  push();

  background(255);

  translate(width/2, height/2);
  rotate(turnAngle);
  translate(-width/2, -height/2);

  if (pixelating) {
    pixelate();
  }

  if (fading) {
    fade();
  }

  if (turning) {
    updateAngle();
  }

  // DRAW SEQUENCE OF PIXELS
  pallete.show(pixelating);

  if (this.makingBin) {
    this.makeBin();
  }
  
  // SAVE
  //if (frameCount == 0 || frameCount % 2 == 0 ) saveFrame("output/img_####.png");

  pop();
}
