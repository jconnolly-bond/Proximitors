
int numParticles = 100;
ArrayList<Proximitor> proximitors = new ArrayList<Proximitor>();
SceneBox box;

void setup() {
  size(800, 800, P3D);

  background(40);
  strokeWeight(2);
  stroke(200);  

  //frameRate(999); // Unlock framerate (?)

  box = new SceneBox(new PVector(0, 0, 0), width/4);

  for (int i = 0; i < numParticles; i++) {
    PVector pos = new PVector(random(-width, width), random(-height, height), random(-width, width));

    // Find valid positions inside scene box
    while (!box.satisfiesEquation(pos)) {
      pos = new PVector(random(-width, width), random(-height, height), random(-width, width));
    }    

    float speed = random(0.5, 1);
    proximitors.add(new Proximitor(pos, speed, i));
  }
  
  
}

void draw() {
  background(40);
  translate(width/2, height/2);    

  text(round(frameRate), -width/2, -height/2+10);

  for (int i = 0; i < proximitors.size(); i++) {
    proximitors.get(i).update();
    proximitors.get(i).show();
  }

  box.show();
}