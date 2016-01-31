ArrayList<MyCircle> circles = new ArrayList<MyCircle>();

void setup() {
  size(800, 600);
  noStroke();
  noiseDetail(24); 
  for (int i=0; i<130; i++) {
    MyCircle circle = new MyCircle();
    circles.add(circle);
  }
}

void draw() {
  background(255);

  for (int i = 0; i< circles.size (); i++) {
    MyCircle circle = circles.get(i);

    for (int j = 0; j< circles.size (); j++) {
      MyCircle circle2 = circles.get(j);
      float distance=dist(circle.x, circle.y, circle2.x, circle2.y);
      if (distance<100) {
        stroke(255, 255/distance*20);
        strokeWeight(1.5);
        line(circle.x, circle.y, circle2.x, circle2.y);
      }
    }
    circle.draw();
  }
}

class MyCircle {
  float xLoc= random(0, 10000);
  float yLoc=random(0, 10000);
  float sLoc=random(0, 10000);
  float s2Loc=random(0, 10000);
  float x, y;
  boolean inner;
  boolean strokes;
  color[] colors = new color[5];
  color c;
  float size = random(80, 200);
  int a = 50;

  MyCircle() {
    colors[0]=color(255, 103, 144, a);
    colors[1]=color(166, 228, 255, a);
    colors[2]=color(95, 91, 118, a);
    colors[3]=color(188, 125, 214, a-10);
    colors[4]=color(255, 239, 219, a);
    c = colors[int(random(0, 5))];
    x = random(0, width);
    y = random(0, height);
    inner = random(0, 2)<1;
    strokes=random(0, 4)<1;
  }

  void update() {
    x = x+map(noise(xLoc), 0, 1, -5, 5);
    y = y+map(noise(yLoc), 0, 1, -5, 5);
    if (x>width+100) {
      x=-100;
    } else if (x<-100) {
      x= width+100;
    }
    if (y>height+100) {
      y=-100;
    } else if (y<-100) {
      y= height+100;
    }
    size = constrain(size+map(noise(sLoc), 0, 1, -0.5, 0.5), 80, 200);
    xLoc+=0.01;
    yLoc+=0.01;
    sLoc+=0.001;
    s2Loc+=0.03;
  }
  void draw() {
    if (!strokes) {
      fill(c);
      noStroke();
      ellipse(x, y, size, size);
    } else {
      stroke(255, 70);
      noFill();
      ellipse(x, y, size, size); 
      ellipse(x, y, map(noise(s2Loc), 0, 1, 30, 60), map(noise(s2Loc), 0, 1, 30, 60));
    }
    if (inner) {
      ellipse(x, y, map(noise(s2Loc), 0, 1, 30, 60), map(noise(s2Loc), 0, 1, 30, 60));
    }
    if (inner) {
      fill(0, 100);
      ellipse(x, y, 5, 5);
    } else {
      fill(255);
      ellipse(x, y, 8, 8);
    }

    update();
  }
}


