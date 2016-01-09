class GameManager {
  int framerate = 60;
  boolean paused = false;
  boolean showStars = true;
  int gameWidth = width-200;
  int gameHeight = 600;
  final float GRAVITY = 6.67e-11;
  ArrayList<CelestialBody> bodies = new ArrayList<CelestialBody>();
  float simulationSpeed = 1;
  
  ArrayList<PVector> stars = new ArrayList<PVector>();
  
  CelestialBody selected;
  
  UserInterface UI;

  GameManager(UserInterface _ui) { 
    UI = _ui;
    int spacing = 270;
    
    for (int i = 0; i < width*height; i+=spacing) {
      int variance = (int)random(-150,150);
      stars.add(new PVector((i%width)+variance,(i/height)+variance)); 
    }
  }
  
  void background()
  {
    if (showStars) {
      for (PVector star : stars) {
        noStroke();
        fill(255);
        ellipse(star.x, star.y, 1, 1);
      }
    }
  }

  void addBody(CelestialBody body) {
    bodies.add(body);
  }

  void cleanUp() {
    for (int i = 0; i < bodies.size(); i++) {
      CelestialBody body = bodies.get(i);
      PVector center = new PVector(width/2, height/2);
      if (body.pos.dist(center) > 5000) {
        bodies.remove(i);
      }
    }
  }

  void update(float dt) {
    for (CelestialBody body : bodies) {
      body.move(dt, simulationSpeed);
      body.acl.set(0,0);
      for (CelestialBody body2 : bodies) {
        if (body != body2) {
          PVector acl = PVector.sub(body2.pos, body.pos);
          acl.setMag((float)(GRAVITY * body2.mass/Math.pow(body.pos.dist(body2.pos),2)));
          body.acl.add(acl);
        }
      }
    }
  }

  void collide() {
    for (int i = 0; i < bodies.size(); i++) {
      CelestialBody body = bodies.get(i);
      for (int j = 0; j < bodies.size(); j++) {
        CelestialBody body2 = bodies.get(j);
        if (body != body2) {
          float dist = body.pos.dist(body2.pos);
          if (dist < body.radius+body2.radius) {
            //Better to do collisions here, no Concurrent exception
            //We should decide what the planets should do.
          }
        }
      }
    }
  }
  
  void removeBody(CelestialBody body)
  {
     bodies.remove(body);
  }

  void draw() {
    background();
    for (CelestialBody body : bodies) {
      body.draw();
    }
    UI.draw(paused, bodies.size(), selected);
  }
}