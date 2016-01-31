
/* @pjs preload="bg.png,box0.png,box1.png,
 box2.png,box3.png,ham0.png,ham1.png,ham2.png,ham3.png,
 life.png,pepper.png, cola.png,
 umaru00.png,umaru01.png,umaru10.png,
 umaru11.png,umaru20.png,umaru21.png"; */
/* @pjs globalKeyEvents="true"; */
import ddf.minim.*;
Minim minim;
AudioPlayer bgm;
AudioPlayer hitSound;
AudioPlayer bonusSound;
PImage bg;
int numFrames = 20;  
int currentFrame = 0;
int score = 0;
int finalScore = 0;
float startTime=0;
int time=0;
boolean gameStart = false;
boolean appended = false;
boolean gameOver;
float maxY=0;
int round;
Umr umr;
Lives lives;
Box[] boxes;
Ham ham;
Bonus[] bonus;
// assume that the canvas size hasn't been altered when the program starts
float scaleX = 1.0;
float scaleY = 1.0;

void setup() {

  frameRate(60);
  minim =new Minim(this);

  bgm = minim.loadFile("bgm.mp3");
  hitSound =  minim.loadFile("hit.mp3");
  bonusSound =  minim.loadFile("bonus.mp3");
  bgm.play();
  bgm.loop();
  size(400, 600);
  gameOver = false;
  bg = loadImage("bg.png");
  ham = new Ham();
  lives = new Lives();
  umr = new Umr(currentFrame);
  boxes = new Box[0];
  bonus = new Bonus[0];
  imageMode(CENTER);
  for (int i=0; i<4; i++) {
    for (int j=0; j<10; j++) {
      boxes= (Box[]) append(boxes, new Box(j+1, i+1));
    }
  }
}

void draw() {
  // compute mouse position based on scale
  // IMPORTANT - use scaledMouseX and scaledMouseY for all mouse positions
  float scaledMouseX = mouseX / scaleX;
  float scaledMouseY = mouseY / scaleY;


  image(bg, width/2, height/2);
  strokeWeight(4);
  stroke(255);
  line(0,500,width,500);
  float currentTime = millis();
  // Use % to cycle through frames
  currentFrame = (currentFrame+1) % numFrames;
  //println(mouseX,mouseY);
  //println(scaledMouseX,scaledMouseY);
  
  //start up
  if (mousePressed && scaledMouseY<240 && scaledMouseY>=220) {
    //easy
    lives.num = 5;
    round = 20;
    gameStart = true;
    startTime=currentTime;
    
  }else if(mousePressed && scaledMouseY<255 && scaledMouseY>=240){
    //normal
    lives.num = 3;
    round = 15;
    gameStart = true;
    startTime=currentTime;
  }else if(mousePressed && scaledMouseY<270 && scaledMouseY>=255){
    //hard
    lives.num = 1;
    round = 10;
    gameStart = true;
    startTime=currentTime;
  }
  
  
  //game start
  if (gameStart) {
    time = int((currentTime - startTime)/1000);
    text(time, width/2, 10);
    lives.drawLives();
    fill(255);
    text("SCORE: "+score, 40, 22);
    umr.drawUmr(currentFrame);
    for (int i=0; i<boxes.length; i++) {
      boxes[i].drawBox();
      if (boxes[i].y > maxY) {
        maxY = boxes[i].y ;
      }
    }
    for (int i=0; i<bonus.length; i++) {
      bonus[i].drawBonus();
    }

    ham.drawHam();
    hitUmr();
    hitBox();
    hitBonus();
    loseLife();
    appendBox(round);
    
    //game over;
    gameover();
  } else {
    fill(255, 220);
    noStroke();
    rect(0, height/2-100, width, 140);
    fill(0);
    textAlign(CENTER);
    text("Select a level", width/2, height/2-60);
    text("Easy", width/2, height/2-20);
    text("Normal", width/2, height/2);
    text("Hard", width/2, height/2+20);
  }
}

void setScale(float w, float h) 
{
  scaleX = w / 500;
  scaleY = h / 500;
}

void appendBox(int round) {

  if ((time%round)==0 && time!=0 && !appended ) {
    appended = true;
    for (int i=0; i<boxes.length; i++) {
      boxes[i].col++;
    }
    for (int i=0; i<10; i++) {
      boxes= (Box[]) append(boxes, new Box(i+1, 1));
    }
  }
  if ((time%round)!=0) {
    appended = false;
  }
}

void loseLife() {
  if (ham.y>=height) {
    ham.x = height/2;
    ham.xDir = 0;
  }
  if(ham.y>=height+300){
  ham.reset(umr.x);
    lives.loseLife();
  }
}

void gameover() {
  if (lives.num<=0 || maxY > 460 ) {
    finalScore = score;
    gameOver = true;
  }
  if (gameOver) {
    background(255);
    fill(0);
    textAlign(CENTER);
    text("Game Over", width/2, height/2);
    text("Score: "+finalScore, width/2, height/2+20);
  }
}

void hitUmr() {
  if (ham.yDir>0 && ham.x>(umr.x-30) && ham.x<(umr.x+30) && ham.y>umr.y-20 ) {
    ham.hitY();
    ham.yDir = abs(ham.yDir);
    if (boolean(int(random(0, 2)))) {
      ham.hitX();
      if (boolean(int(random(0, 2)))) {
        ham.xDir = random(-2, 0);
      } else {
        ham.xDir = random(0, 2);
      }
      ham.yDir = sqrt(13-sq(ham.xDir));
    }
    hitSound.play();
    //println("hit umaru");
  }
}

void hitBonus() {
  for (int i=0; i<bonus.length; i++) {
    if ( dist(umr.x, umr.y, bonus[i].x, bonus[i].y) <= 20 && bonus[i].display) {
      bonus[i].display = false;
      
      if (bonus[i].kind == 0) {
        bonusSound.play();
        lives.num+=1;
      } else if (bonus[i].kind == 1) {
        lives.num-=1;
      } else {
        score +=500;
        bonusSound.play();
      }
    }
  }
}


void hitBox() {
  for (int i=0; i<boxes.length; i++) {
    //hit top bottom
    if ((ham.x >= (boxes[i].x-30) && ham.x<=(boxes[i].x+30)) && ham.y >=(boxes[i].y-30) && ham.y <=(boxes[i].y+30) ) {
      ham.hitY();
      hitSound.play();
      //bonus
      if (int(random(0, 5))==0) {
        bonus= (Bonus[]) append(bonus, new Bonus(boxes[i].x, boxes[i].y));
        bonus[bonus.length-1].addBonus();
      }
      score+=100;
      boxes[i].hide();
      //println( "hit box");
    } else if ((ham.y >= (boxes[i].y-30) && ham.y<=(boxes[i].y+30)) && ham.x >=(boxes[i].x-30) && ham.x <=(boxes[i].x+30)) {
      ham.hitX();
      hitSound.play();
      if (int(random(0, 5))==0) {
        bonus= (Bonus[]) append(bonus, new Bonus(boxes[i].x, boxes[i].y));
        bonus[bonus.length-1].addBonus();
      }
      score+=100;
      boxes[i].hide();
      //println( "hit box");
    }
  }
}

class Bonus {
  PImage life;
  PImage cola;
  PImage pepper;
  PImage img;
  float x;
  float y;
  boolean display;
  int kind;

  //0 for life, 1 for pepper, 2 for cola,

  Bonus(float tempX, float tempY) {
    x=tempX;
    y= tempY;
    life = loadImage("life.png");
    pepper = loadImage("pepper.png");
    cola = loadImage("cola.png");

    display = false;
  }

  void drawBonus() {
    if (display) {
      image(img, x, y);
      y+=1.5;
    }
  }

  void addBonus() {
    kind = int(random(0, 3));
    if ( kind == 0) {
      img = life;
    } else if (kind == 1) {
      img = pepper;
    } else {
      img = cola;
    }
    display = true;
  }
}

class Box {
  float x;
  float y;
  PImage[] boxes = new PImage[4];
  PImage box;
  int kind;
  int line;
  int col;
  boolean display;

  Box(int tempLine, int tempCol) {
    display = true;
    boxes[0]=loadImage("box0.png");
    boxes[1]=loadImage("box1.png");
    boxes[2]=loadImage("box2.png");
    boxes[3]=loadImage("box3.png");
    kind = int(random(0, 4));
    box = boxes[kind];
    line = tempLine;
    col = tempCol;
    x = line*40-20;
    y = col*40+80-20;
  }

  void drawBox() {
    if (display) {
          x = line*40-20;
    y = col*40+80-20;
      fill(100, 100);
      noStroke();
      rect(x-20, y, 40, 30);
      image(box, x, y);
    }
  }

  void hide() {
    x = 0;
    y = 0;
    display = false;
  }
}

class Ham {
  float x;
  float y;
  float xDir;
  float yDir;
  int xFlag;
  int yFlag;
  PImage[] imgs = new PImage[4];
  int dir;
  boolean run;

  Ham() {
    run = false;
    x = width/2;
    y = height - 60;
    xDir = 0;
    yDir = 0;
    xFlag = 0;
    yFlag = 0;
    dir = 0;
    imgs[0] = loadImage("ham0.png");
    imgs[1] = loadImage("ham1.png");
    imgs[2] = loadImage("ham2.png");
    imgs[3] = loadImage("ham3.png");
  }

  void drawHam() {
    //
    if (keyPressed && xDir ==0 && yDir ==0) {
      xDir = (int(random(0, 2))*2-1)*3;
      yDir = -2;
      run = true;
    }
    
    //update
    if (run) {
      if (xFlag == 1) {
        xDir = -abs(xDir);
        xFlag = 0;
      } else if (xFlag == -1) {
        xDir = abs(xDir);
        xFlag = 0;
      }
      if (yFlag == 1) {
        yDir = -abs(yDir);
        yFlag = 0;
      } else if (yFlag == -1) {
        yDir = abs(yDir);
        yFlag = 0;
      }
      x+=xDir;
      y+=yDir;
      image(imgs[dir], x, y);
      //check Ham bouncing, flip direction
      if (x>width-10 || x<10) {
        xDir *=-1;
        dir =int(random(0, 3));
      }
      if (y<90) {
        yDir *=-1;
        dir = int(random(0, 3));
      }
    }else{
       image(imgs[0], x, y);
    }
  }

  void hitX() {
    //xDir *=-1;
    if (xDir > 0) {
      xFlag = 1;
    } else {
      xFlag = -1;
    }
  }
  void hitY() {
    if (yDir > 0) {
      yFlag = 1;
    } else {
      yFlag = -1;
    }
  }

  void reset(float tempX) {
        image(imgs[0], x, y);
    xDir = 0;
    yDir =0;
    x = tempX;
    y = height - 60;
    run = false;
  }
}

class Lives {
  PImage life;
  int num;

  Lives() {
    num = 3;
    life = loadImage("life.png");
    for (int i=0; i<num; i++) {
      image(life,width-(i+2)*12,20);
    }
  }
  
  void drawLives(){
    for (int i=0; i<num; i++) {
      image(life,width-(i+2)*12,20);
    }
  }
  
  void getLife(){
    num++;
  }
  
  void loseLife(){
    num--;
  }
}

class Umr {
  float x;
  float y;
  PImage[] up = new PImage[2];
  PImage[] left = new PImage[2];
  PImage[] right = new PImage[2];
  float speed =5;
  int cut;
  boolean keyRight=false;
  boolean keyLeft=false;
  int currentFrame;

  Umr(int tempCurrentFrame) {
    x = width/2;
    y = height - 40;
    cut = 0;
    currentFrame=tempCurrentFrame;
    up[0] = loadImage("umaru00.png");
    up[1] = loadImage("umaru01.png");
    left[0] = loadImage("umaru10.png"); 
    left[1] = loadImage("umaru11.png");
    right[0] = loadImage("umaru20.png"); 
    right[1] = loadImage("umaru21.png");
  }

  void reset() {
    x = width/2;
    y = height - 40;
  }

  void drawUmr(int currentFrame) {
    //change cut
    if (currentFrame <=10) {
      cut = 0;
    } else {
      cut = 1;
    }

    //move
    if (keyRight) {
      x+=speed;
      image(right[cut], x, y);
    } else if (keyLeft) {
      x-=speed;
      image(left[cut], x, y);
    } else {
      image(up[cut], x, y);
    }

    //check bouncing
    if (x<=20) {
      x=20;
    }
    if (x>=width-20) {
      x=width-20;
    }

    if (keyPressed) {
      if (keyCode ==RIGHT) {
        keyRight= true;
      }
      if (keyCode ==LEFT) {
        keyLeft=true;
      }
    } else {
      keyRight = false;
      keyLeft=false;
    }
  }
}


