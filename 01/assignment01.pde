int x, y;
void setup() {
  size(400, 600);
  background(255);
  smooth();
  frameRate(10);
}

void draw() {
  noStroke();
  fill(int(random(200, 255)), int(random(200, 255)), int(random(200, 255)), 60);
  ellipse(mouseX+int(random(-100, 100)), mouseY+int(random(-100, 100)), 50, 50);
  ellipse(width-mouseX+int(random(-100, 100)), mouseY+int(random(-100, 100)), 50, 50);
  drawTree();
  drawStar();
  drawDeco();
  fill(50, 50, 50, 40);
  rect(0, 0, width, height);
}

void drawDeco(){
  fill(255,140,140,100);
  ellipse(100,400,30,30);
  ellipse(200,290,30,30);
  ellipse(210,370,30,30);
  ellipse(160,190,30,30);
  ellipse(240,180,30,30);
  ellipse(130,243,30,30);
  ellipse(180,462,30,30);
  ellipse(300,490,30,30);
  ellipse(70,480,30,30);
  ellipse(320,420,30,30);
  ellipse(302,342,30,30);
    fill(255,255,255,100);
  ellipse(100,400-15,5,5);
  ellipse(200,290-15,5,5);
  ellipse(210,370-15,5,5);
  ellipse(160,190-15,5,5);
  ellipse(240,180-15,5,5);
  ellipse(130,243-15,5,5);
  ellipse(180,462-15,5,5);
  ellipse(300,490-15,5,5);
  ellipse(70,480-15,5,5);
  ellipse(320,420-15,5,5);
  ellipse(302,342-15,5,5);
}

void drawTree() {
  fill(100, 140, 140, 40);
  triangle(width/2, 100, 50, 520, width-50, 520);
  stroke(100, 140, 140, 40);
  strokeWeight(3);
  for (int x=40; x<=width/2; x+=10) {
    line(width/2, 100, x+50, 300+x/10);
    line(width/2, 100, width-x-50, 300+x/10);
    line(width/2, 100, x+30, 400+x/10);
    line(width/2, 100, width-x-30, 400+x/10);
    line(width/2, 100, x, 500+x/10);
    line(width/2, 100, width-x, 500+x/10);
    line(width/2, 100, x, 520+x/10);
    line(width/2, 100, width-x, 520+x/10);
  }
}

void drawStar() {
  noStroke();
  fill(255, int(random(0, 5)));
  int d = int(random(90, 100));
  ellipse(width/2, 100, d, d);
  fill(255, 255, 200, 10);
  ellipse(width/2, 100, 50, 50);
  fill(255, 255, 200);
  star(width/2, 100, 10, 20, 5);
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}


