PVector[] windParticles = new PVector[1000];
PVector getNormalizedPVector(int direction) {
  int numPoints = 360;
  float angle = TWO_PI/(float)numPoints;
  direction = 360-direction;
  direction += 180;
  return new PVector(sin(angle*direction), cos(angle*direction));
}

void setup() {
  frameRate(10);
  size(1200, 650);
  smooth();
  background(153, 153, 153);
  for (int i=0; i<windParticles.length; i++) {
    windParticles[i] = new PVector(random(width), random(height));
  }
}

void draw() {
  background(153, 153, 153);
  fill(255, 120, 120);
  drawWind();
  fill(79, 255, 211);
  drawWind();
}

void drawWind() {
  noStroke(); 
  float windSize = random(36, 40);
  for (int i=0; i<windParticles.length-500; i=i+10) {
    windParticles[i].add(getNormalizedPVector(0));
    if (windParticles[i].x<0)windParticles[i].x=width;
    if (windParticles[i].x>width)windParticles[i].x=0;
    if (windParticles[i].y<200)windParticles[i].y=height;
    if (windParticles[i].y>height)windParticles[i].y=0;

    int x1=int(windParticles[i].x+random(-5, 5));
    int y1=int(windParticles[i].y+random(-5, 5));
    int x2=int(windParticles[i].x+random(-5, 5));
    int y2=int(windParticles[i].y+random(-5, 5));
    int x3=int(windParticles[i].x+random(-5, 5));
    int y3=int(windParticles[i].y+random(-5, 5));
    triangle(x1, y1, x2, y2, x3, y3);
  }
}


