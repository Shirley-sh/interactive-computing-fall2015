/* @pjs preload="bg.png,coin.png,coin201.png,coin202.png,over.png,char101.png,char102.png,char103.png,char104.png,char201.png,char202.png,char203.png,char204.png,life.png";*/


int numFrames = 60;  // The number of frames in the animation
int currentFrame = 0;
int level = 0;
Enemy[] enemies;
Hero hero;
float coin1X;
float coin1Y;
float coin2X=1;
float coin2Y=2;
float coin2XDir;
float coin2YDir;
int score;
int heart;
int heartLose;
PImage life;
PImage coin1;
PImage coin201;
PImage coin202;
PImage bg;
PImage over;
float timer;
int delayedTime;


void setup() {
  size(500, 500);
  smooth();
  imageMode(CENTER);
  background(150);
  frameRate(60);
  enemies = new Enemy[0];
  enemies = (Enemy[]) append(enemies, new Enemy(currentFrame, level));
  hero = new Hero();
  coin1X = random(0, width);
  coin1Y = random(40, height);
  coin2X = random(0, width);
  coin2Y = random(40, height);
  coin2XDir=random(0.3, 0.5);
  coin2YDir=random(0.3, 0.5);
  score = 0;
  heart=5;
  heartLose = 0;
  life = loadImage("life.png");
  coin1 = loadImage("coin.png");
  coin201 = loadImage("coin201.png");
  coin202 = loadImage("coin202.png");
  bg = loadImage("bg.png");
  over = loadImage("over.png");
  timer = 10000;
  delayedTime = 10000;
}

void draw() {
  int m = millis();
  if (delayedTime == 0) {
    drawBackground();
    // Use % to cycle through frames
    currentFrame = (currentFrame+1) % numFrames;
    setCoins();
    for (int i = 0; i<level; i++) {
      enemies[i].display(currentFrame);
      //check heart lose;
      if (dist(enemies[i].x, enemies[i].y, hero.x, hero.y)<20) {
        delayedTime = 60;
        fill(255,0,0);
        text("Life -1", width/2+20,60);
        heartLose++;
        hero.reset();
      }
    }
    hero.display();
    fill(255);
    textAlign(LEFT);
    text("SCORE: ", 10, 25); 
    text(str(score), 60, 25);
    text("LIFE: ", width-100, 25);
    textAlign(CENTER, BOTTOM);
    text("Time", width/2+20, 25);
    fill(255, 255, 0);
    text(str((timer-m)/1000), width/2+23, 40);

    //level up
    //coin1
    if (dist(coin1X, coin1Y, hero.x, hero.y)<15) {
      delayedTime = 30;
      textAlign(CENTER);
      text("  +100   ", coin1X+40, coin1Y-40);
      text("Time +3!!", coin1X+40, coin1Y-20);
      level++;
      score += 100;
      enemies = (Enemy[]) append(enemies, new Enemy(currentFrame, level));
      timer+=4000;
      //reset coin  
      coin1X = random(0, width);
      coin1Y = random(60, height);
    }
    //coin2
    if (dist(coin2X, coin2Y, hero.x, hero.y)<15) {
      delayedTime = 30;
      textAlign(CENTER);
      text("  +500   ", coin2X+40, coin2Y-40);
      text("Time +5!!", coin2X+40, coin2Y-20);
      level++;
      score += 500;
      enemies = (Enemy[]) append(enemies, new Enemy(currentFrame, level));
      timer+=6000;
      //reset coin  
      coin2X = random(0, width);
      coin2Y = random(60, height);
      coin2XDir=random(0.3, 0.5);
      coin2YDir=random(0.3, 0.5);
    }


    //game over
    if ((heart-heartLose)<=0 || (timer-m) <=0) {
      hero.reset();
      fill(150);
      rect(0, 0, width, height);
      fill(255);
      textAlign(CENTER, BOTTOM);
      textSize(30);
      text("GAME OVER", width/2, height/2-20); 
      text("SCORE: "+str(score), width/2, height/2+20);
      image(over,width/2,height/2+60);
    }
  } else if (delayedTime == 10000) {
    textAlign(CENTER, BOTTOM);
    textSize(30);
    text("Click to Start", width/2, height/2-20);
    image(bg, width/2, height/2+100);
    if (mousePressed) {
      delayedTime = 0;
      timer += m;
    }
  } else {
    delayedTime -= 1;
  }
}

void drawBackground() {
  background(150);
  noStroke();
  fill(100);
  rect(0, 0, width/2-40, 40);
  rect(width/2+40, 0, width/2-40, 40);
  image(life, width-40, 20);
  rect(width-68, 0, heartLose*11, 40);
}

void setCoins() {
  coin2X += coin2XDir;
  coin2Y += coin2YDir;
  float xOffset = hero.x-coin2X;
  float yOffset = hero.y-coin2Y;
  if ((xOffset*coin2XDir)>0) {
    coin2XDir*=-1;
  }
  if ((yOffset*coin2YDir)>0) {
    coin2YDir*=-1;
  }
  //check bouncing
  if (coin2X<=10 || coin2X>=width-10 || coin2Y<=60 || coin2Y>=height-10) {
    coin2X = random(0, width);
    coin2Y = random(40, height);
  }
  image(coin1, coin1X, coin1Y);
  if (currentFrame <=30) {
    image(coin201, coin2X, coin2Y);
  } else {
    image(coin202, coin2X, coin2Y);
  }
}

class Enemy {
  float x ;
  float y ;
  float xDir;
  float yDir;
  int level;
  int speed;
  int currentFrame;
  PImage[] img = new PImage[20];
  color[] c = new color[4];

  Enemy(int tempCurrentFrame, int tempLevel) {
    x=random(40, width-40);
    y=random(100, height-40);
    level=tempLevel;
    currentFrame=tempCurrentFrame;
    if(random(1) < 0.5){
      speed = 0;
    }else{
    speed = level %4;
    }
    xDir=random(0.1, 0.3)*(speed+1);
    yDir=random(0.3, 0.5)*(speed+1);
    img[0] = loadImage("char101.png");
    img[1] = loadImage("char102.png");
    img[2] = loadImage("char103.png");
    img[3] = loadImage("char104.png");
    c[0]=color(255, 255, 255);
    c[1]=color(106, 204, 204);
    c[2]=color(255, 255, 43);
    c[3]=color(255, 69, 69);
  }

  void display(int currentFrame) {
    //load img
    if (currentFrame <=30) {
      if (xDir <0) {
        tint(c[speed]);
        image(img[2], x, y);
        noTint();
      } else {
        tint(c[speed]);
        image(img[0], x, y);
        noTint();
      }
    } else {
      if (xDir <0) {
        tint(c[speed]);
        image(img[3], x, y);
        noTint();
      } else {
        tint(c[speed]);
        image(img[1], x, y);
        noTint();
      }
    }
    //update position
    x+=xDir;
    y+=yDir;
    //check bouncing and flip direction
    if (x>width-20 || x<20) {
      xDir *=-1;
    }
    if (y>height-20 || y<60) {
      yDir *=-1;
    }
  }
}

class Hero {
  PImage[] img = new PImage[4];
  float x ;
  float y ;
  //control
  boolean up = false;
  boolean down= false;
  boolean right = false;
  boolean left = false;
  int direction;
  

  Hero() {
    up = false;
    down= false;
    right = false;
    left = false;
    direction=0;
    img[0] = loadImage("char201.png");
    img[1] = loadImage("char202.png");
    img[2] = loadImage("char203.png");
    img[3] = loadImage("char204.png");
    x = width/2;
    y = 100;
  }

  void reset() {
    x = width/2;
    y = 100;
  }

  void display() {
    image(img[direction], x, y);
    //move
    if (right) {
      x+=5;
      direction=2;
    }
    if (left) {
      x-=5;
      direction=1;
    }
    if (up) {
      y-=5;
      direction=3;
    }
    if (down) {
      y+=5;
      direction=0;
    }

    //check bouncing
    if (x<=10) {
      x=10;
    }
    if (x>=width-10) {
      x=width-10;
    }
    if (y<=10) {
      y=10;
    }
    if (y>=height-10) {
      y=height-10;
    }
  }
}

void keyPressed(){
  if (key=='d' || keyCode ==RIGHT) {
        hero.right = true;
      }
      if (key=='s' || keyCode ==DOWN) {
        hero.down= true;
      }
      if (key=='w' || keyCode ==UP) {
        hero.up=true;
      }
      if (key=='a' || keyCode ==LEFT) {
        hero.left=true;
}}

void keyReleased(){
  if (key=='d'|| keyCode ==RIGHT) {
        hero.right = false;
      }
      if (key=='s'|| keyCode ==DOWN) {
        hero.down= false;
      }
      if (key=='w'|| keyCode ==UP) {
        hero.up=false;
      }
      if (key=='a'|| keyCode ==LEFT) {
        hero.left=false;
}}

