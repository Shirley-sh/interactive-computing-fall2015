var circles = [];

function setup() {
	createCanvas(800, 600);
	noStroke();
	noiseDetail(24);
	for (var i = 0; i < 130; i++) {
		circles.push(new MyCircle());
	}
}

function draw() {
	background(255);
	for (var i = 0; i < circles.length; i++) {
		for (var j = 0; j < circles.length; j++) {
			var distance = dist(circles[i].x, circles[i].y, circles[j].x, circles[j].y);
			if (distance < 100) {
				stroke(255, 255 / distance * 20);
				strokeWeight(1.5);
				line(circles[i].x, circles[i].y, circles[j].x, circles[j].y);
			}
		}
		circles[i].draw();
	}
}

function MyCircle() {
	this.xLoc = random(0, 10000);
	this.yLoc = random(0, 10000);
	this.sLoc = random(0, 10000);
	this.s2Loc = random(0, 10000);
	this.colors = [];
	this.size = random(80, 200);
	this.a = 50;
	this.colors.push(color(255, 103, 144, this.a));
	this.colors.push(color(166, 228, 255, this.a));
	this.colors.push(color(95, 91, 118, this.a));
	this.colors.push(color(188, 125, 214, this.a - 10));
	this.colors.push(color(255, 239, 219, this.a));
	this.c = this.colors[int(random(0, 5))];
	this.x = random(0, width);
	this.y = random(0, height);
	this.inner = random(0, 2) < 1;
	this.strokes = random(0, 4) < 1;
	this.update = function() {
		this.x = this.x + map(noise(this.xLoc), 0, 1, -5, 5);
		this.y = this.y + map(noise(this.yLoc), 0, 1, -5, 5);
		if (this.x > width + 100) {
			this.x = -100;
		} else if (this.x < -100) {
			this.x = width + 100;
		}
		if (this.y > height + 100) {
			this.y = -100;
		} else if (this.y < -100) {
			this.y = height + 100;
		}
		this.size = constrain(this.size + map(noise(this.sLoc), 0, 1, -0.5, 0.5), 80, 200);
		this.xLoc += 0.01;
		this.yLoc += 0.01;
		this.sLoc += 0.001;
		this.s2Loc += 0.03;
	}
	this.draw = function() {
		if (!this.strokes) {
			fill(this.c);
			noStroke();
			ellipse(this.x, this.y, this.size, this.size);
		} else {
			stroke(255, 70);
			noFill();
			ellipse(this.x, this.y, this.size, this.size);
			ellipse(this.x, this.y, map(noise(this.s2Loc), 0, 1, 30, 60), map(noise(this.s2Loc), 0, 1, 30, 60));
		}
		if (this.inner) {
			ellipse(this.x, this.y, map(noise(this.s2Loc), 0, 1, 30, 60), map(noise(this.s2Loc), 0, 1, 30, 60));
		}
		if (this.inner) {
			fill(0, 100);
			ellipse(this.x, this.y, 5, 5);
		} else {
			fill(255);
			ellipse(this.x, this.y, 8, 8);
		}

		this.update();
	}
}