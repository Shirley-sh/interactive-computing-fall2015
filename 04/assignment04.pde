

/* @pjs preload="barrel.png,bg.png,cat0.png,cat1.png,cat2.png,cat2.png,face0.png,face1.png,face2.png,gameover.png,mouse0.png,mouse1.png,pugi0.png,pugi1.png"; */
/* @pjs globalKeyEvents="true"; */

import ddf.minim.*;
Cat[] cats;

Minim minim;
AudioPlayer meow0;
AudioPlayer meow1;
AudioPlayer meow2;
AudioPlayer bgm;
int life;
PImage hold;
PImage drop;
PImage mouse;
PImage gameover;
PImage bg;
int counter;
int score;
int finalScore;
int gameoverCount;
boolean start;
// assume that the canvas size hasn't been altered when the program starts
float scaleX = 1.0;
float scaleY = 1.0;
float scaledMouseX;
float scaledMouseY;

void setup() {


  minim =new Minim(this);
  size(600, 600);
  meow0= minim.loadFile("meow0.mp3");
  meow1= minim.loadFile("meow1.mp3");
  meow2= minim.loadFile("meow2.mp3");
  bgm = minim.loadFile("bgm.mp3");
  bgm.play();
  bgm.loop();
  imageMode(CENTER);
  hold = loadImage("mouse0.png");
  drop = loadImage("mouse1.png");
  gameover=loadImage("gameover.png");
  bg = loadImage("bg.png");
  frameRate(60);
  counter=0;
  gameoverCount=100;
  mouse = hold;
  cats = new Cat[9];
  for (int i=0; i<3; i++) {
    for (int j=0; j<3; j++) {
      cats[i*3+j] = new Cat(150*(i+1), 150*(j+1));
    }
  }
  start = false;
    textSize(20);
}

void draw() {
  // compute mouse position based on scale
  // IMPORTANT - use scaledMouseX and scaledMouseY for all mouse positions
  scaledMouseX = mouseX / scaleX;
  scaledMouseY = mouseY / scaleY;

  background(#DB9F9F);
  textAlign(CENTER);
  text("Click to Start", width/2, height/2);
  if(mousePressed){
    start = true;
  }
  if(start){
      noCursor();
  gameStart();
  }
  //gameover
  gameOver();
  


  //delay
  counter--;
  if (counter<0) {
    mouse = hold;
  }
}


void gameStart(){
  score = 0;
  life = 5;
  background(#DB9F9F);
  image(bg,width/2,height/2);
  fill(0);
  textAlign(CENTER);
  for (int i=0; i<9; i++) {
    cats[i].display();
    life += cats[i].life;
    score += cats[i].score*100;
  }
  image(mouse, scaledMouseX, scaledMouseY);
  fill(#71513C);
  text("SCORE: "+score+"; LIFE: "+life, width/2, 40);
}


void gameOver(){
  if (start && life<=0) {
    finalScore = score;
    gameoverCount--;
    background(255);
    fill(#333333);
    text("SCORE: "+finalScore, width/2, height/2-160);
    image(gameover, width/2, height/2);
    text("GAMEOVER", width/2, height/2-200);
    if (gameoverCount<=0) {
      if (gameoverCount%30 > -15) {
        text("Click to Restart", width/2, height/2+200);
      }
      if (mousePressed) {
        for (int i=0; i<9; i++) {
          cats[i].reset();
          cats[i].life=0;
          cats[i].score=0;
        }
        life=5;
        score=0;
      }
    } 
}
}

//delay
void mousePressed() {
  counter = 20;
  if (counter>0) {
    mouse = drop;
  }
}
class Cat {
  PImage[] bodies = new PImage[4];
  PImage[] faces = new PImage[3];
  PImage[] pig = new PImage[2];
  PImage barrel;
  int status;
  int counter;
  float x;
  float y;
  int bodyType;
  boolean hit;
  boolean appear;
  boolean isPig;
  int score;
  int life;
  int angle;
  AudioPlayer meow;


  Cat(int tempX, int tempY) {
    x = tempX;
    y = tempY;
    bodies[0]=loadImage("cat0.png");
    bodies[1]=loadImage("cat1.png");
    bodies[2]=loadImage("cat2.png");
    bodies[3]=loadImage("cat3.png");
    //face: 0=normal, 1=angry, 2=hit;
    faces[0]=loadImage("face0.png");
    faces[1]=loadImage("face1.png");
    faces[2]=loadImage("face2.png");

    pig[0]=loadImage("pugi0.png");
    pig[1]=loadImage("pugi1.png");
    barrel=loadImage("barrel.png");

    angle = int(random(0, 360));
    //status: 0=disappear; 1=appear; 2=angry; 3=hit;
    status = 0;
    counter = int(random(3, 10)*30);
    bodyType = int(random(0, 4));
    hit = false;
    appear = false;
    isPig = false;
    score = 0;
    life = 0;
    if (random(0, 3)<1) {
      meow = meow0;
    } else if (random(0, 3)<2) {
      meow = meow1;
    } else {
      meow = meow2;
    }
  }

  void display() {
    if (isPig) {
      checkhit();
      changePigStatus();
      drawPig();
    } else {
      checkhit();
      changeCatStatus();
      drawCat();
    }
    countdown();
  }

  void reset() {
    hit = false;
    appear = false;
    status=0;
    counter=int(random(3, 10)*40);
    bodyType = int(random(0, 4));
    if (random(0, 5)<1) {
      isPig = true;
    } else {
      isPig = false;
    }
    if (random(0, 3)<1) {
      meow = meow0;
    } else if (random(0, 3)<2) {
      meow = meow1;
    } else {
      meow = meow2;
    }
  }

  void checkhit() {
    if ((!hit) && appear && mousePressed && scaledMouseX>x-75 && scaledMouseX<x+75
      && scaledMouseY>y-75 && scaledMouseY<y+75) {
      hit = true;
    }
  }

  void drawPig() {
    //draw image
    if (status==0) {
      //disappear
      image(barrel, x, y);
    } else if (status==1) {
      //appear
      pushMatrix();
      translate(x, y);
      rotate(radians(angle));
      image(pig[0], 0, 0);
      popMatrix();
    } else if (status==2) {
      //angry
      pushMatrix();
      translate(x, y);
      rotate(radians(angle));
      image(pig[0], 0, 0);
      popMatrix();
    } else if (status==3) {
      //hit
      pushMatrix();
      translate(x, y);
      rotate(radians(angle));
      image(pig[1], 0, 0);
      popMatrix();
    }
  }

  void changePigStatus() {
    //change status
    if (status==0 && counter==0) {
      //appear
      appear = true;
      status=1;
      counter = 2*30;
    } else if (status==1 && counter==0) {
      //become angry
      status=2;
      counter =60;
    } else if ((status==1 || status==2) && hit) {
      //hit
      hit = false;
      life--;
      status=3;
      counter=30;
    } else if (status==3 && counter==0) {
      //hitted, disappear
      reset();
    } else if (status==2 && counter==0) {
      //angry, disappear
      reset();
    }
  }

  //----------------------------------------

  void drawCat() {
    //draw image
    if (status==0) {
      //disappear
      image(barrel, x, y);
    } else if (status==1) {
      //appear
      pushMatrix();
      translate(x, y);
      rotate(radians(angle));
      image(bodies[bodyType], 0, 0);
      image(faces[0], 0, 0);
      popMatrix();
    } else if (status==2) {
      //angry
      pushMatrix();
      translate(x, y);
      rotate(radians(angle));
      image(bodies[bodyType], 0, 0);
      image(faces[1], 0, 0);
      popMatrix();
    } else if (status==3) {
      //hit
      pushMatrix();
      translate(x, y);
      rotate(radians(angle));
      image(bodies[bodyType], 0, 0);
      image(faces[2], 0, 0);
      popMatrix();
    }
  }

  void changeCatStatus() {
    //change status
    if (status==0 && counter==0) {
      //appear
      appear = true;
      status=1;
      counter = 4*30;
    } else if (status==1 && counter==0) {
      //become angry
      status=2;
      counter =2*60;
    } else if ((status==1 || status==2) && hit) {
      //hit
      hit = false;
      score++;
      status=3;
      counter=30;
      meow.play(0);
    } else if (status==3 && counter==0) {
      //hitted, disappear
      reset();
    } else if (status==2 && counter==0) {
      //angry, disappear
      life--;
      reset();
    }
  }

  void countdown() {
    //countdown time;
    counter -= 1;
  }
}

void setScale(float w, float h) 
{
  scaleX = w / 600;
  scaleY = h / 600;
}



