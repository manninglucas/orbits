//manages all the game variables
class GameManager {
  boolean mouseDragged; //For planet spawning
  boolean paused = false;
  boolean showStars = true;
  final float GRAVITY = 6.67e-11;
  ArrayList<CelestialBody> bodies = new ArrayList<CelestialBody>();
  float simulationSpeed = 1;
  boolean drawFun = false;
  boolean debug = false;

  //holds all the star positions 
  ArrayList<PVector> stars = new ArrayList<PVector>();

  //the current planet selected by the user  
  CelestialBody selected;

  //game has control of the UI  
  UserInterface UI;

  GameManager(UserInterface _ui) { 
    UI = _ui;
    
    //relative spacing between stars with no variance
    int spacing = 270;
    
    //add variance to star position 
    for (int i = 0; i < width*height; i+=spacing) {
      int variance = (int)random(-150,150);
      stars.add(new PVector((i%width)+variance,(i/height)+variance)); 
    }
  }
  
  //draws the background 
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

  //deletes planets that are realllllly far away
  void cleanUp() {
    for (int i = 0; i < bodies.size(); i++) {
      CelestialBody body = bodies.get(i);
      PVector center = new PVector(width/2, height/2);
      if (body.pos.dist(center) > 5000) {
        bodies.remove(i);
      }
    }
  }

  //upsate physics variables and positions
  void update(float dt) {
    //go through every body and move it. Then reset acceleration
    for (CelestialBody body : bodies) {
      body.move(dt, simulationSpeed);
      body.acl.set(0,0);
      
      //go through every other body and add acceleration due to these
      for (CelestialBody body2 : bodies) {
        if (body != body2) {
          //SCIENCE
          PVector acl = PVector.sub(body2.pos, body.pos);
          acl.setMag((float)(GRAVITY * body2.mass/Math.pow(body.pos.dist(body2.pos),2)));
          body.acl.add(acl);
        }
      }
    }
  }
 
  //draws all the things
  void draw() {
    background();
    for (CelestialBody body : bodies) {
      body.draw();
    }
    UI.draw(paused, bodies.size(), selected);
  }
}