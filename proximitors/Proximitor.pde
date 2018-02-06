class Proximitor {

  PVector pos;
  PVector dir;
  float speed;
  int index;
  Proximitor mate;
  ArrayList<Proximitor> mates = new ArrayList<Proximitor>();
  int outOfBounds = 0;

  Proximitor(PVector p, float s, int i) {
    pos = p;
    speed = s;
    index = i;

    dir = PVector.random3D();
  }

  void show() {
    strokeWeight(2.5);
    stroke(200);
    point(pos.x, pos.y, pos.z);
    if (!mates.isEmpty()) {
      strokeWeight(0.5);
      for (int i = 0; i < mates.size(); i++) {
        line(pos.x, pos.y, pos.z, mates.get(i).getPos().x, mates.get(i).getPos().y, mates.get(i).getPos().z);
      }
    }
  }

  void update() {
    PVector direction = new PVector(dir.x, dir.y, dir.z); 
    PVector vel = direction.mult(speed);
    pos.add(vel);
    edges();
    chooseMate();
  }

  void edges() {    
    if (!box.satisfiesEquation(pos)) {
      // If out of bounds then reverse direction
      outOfBounds++;
      dir = dir.mult(-1);
      // todo, add impact effect
    } else {
      outOfBounds = 0;
    }

    // If a proximitor has been outside of the scene cube
    // for longer than 10 correct attempts then reset to centre
    // Quick fix, could annimate with a *pop*
    if (outOfBounds > 10) {
      pos = new PVector(random(-width, width), random(-height, height), random(-width, width));
      while (!box.satisfiesEquation(pos)) {
        pos = new PVector(random(-width, width), random(-height, height), random(-width, width));
      }  
      dir = PVector.random3D();
    }
  }  

  // Logic for choosing proximitors in close proximity to eachother
  void chooseMate() {
    mates.clear();
    // Choose several close mates
    float maxDist = 50;
    for (int i = 0; i < proximitors.size(); i++) {
      if (i != index) {
        float d = pos.dist(proximitors.get(i).getPos());
        if (d < maxDist) {         
          mates.add(proximitors.get(i));
        }
      }
    }
  }

  PVector getPos() {
    return pos;
  }
}