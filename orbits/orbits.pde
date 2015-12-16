/*TODO: planet collisions?
        customiztion of planets
        user input panel
        mouse throw initial velocity
        acceleration calculation
*/

abstract class CelestialBody {
  PVector vel; //velocity
  PVector acl = new PVector(0,0); //acceleration
  PVector pos; //position
  PVector dpos = new PVector(0,0); //change in position to next frame: delta pos
  long mass;
  float radius;
  color col;
  
  CelestialBody(PVector ipos, PVector ivel, 
                long imass, float iradius, color icol) {       
    pos = ipos;
    vel = ivel;
    mass = imass;
    radius = iradius;
    col = icol;
  }
  
  void move(float dt) {
    vel.add(PVector.mult(acl,dt));
    dpos = PVector.mult(vel, dt).add(PVector.mult(acl,0.5*dt*dt));
    pos.add(dpos);
  }
  
  void draw() {
    fill(col);
    ellipse(pos.x, pos.y, radius, radius);
  }
  
  void intersect() {
    
  }
  
  void collide() {
    
  }
}

class Planet extends CelestialBody {
  
  Planet(PVector ipos, PVector ivel, long imass,
         float iradius, color icol) {
    super(ipos, ivel, imass, iradius, icol);
  }
  
  void move(float dt) {
    super.move(dt);
    println(vel);  
  }
  
}

class Star extends CelestialBody {
  Star(PVector ipos, PVector ivel, long imass,
         float iradius, color icol) {
    super(ipos, ivel, imass, iradius, icol);
  }
}

class GameManager {
  int framerate = 60;
  boolean paused = false;
  int gameWidth = 800;
  int gameHeight = 600;
  final float GRAVITY = .0000001;
  
  ArrayList<CelestialBody> bodies = new ArrayList<CelestialBody>(); 

  GameManager() {
    
  }
  
  void addBody(CelestialBody body) {
    bodies.add(body);
  }
  
  void update(float dt) {
    for (CelestialBody body : bodies) {
      body.move(dt);
      for (CelestialBody body2 : bodies) {
        if (body != body2) {
          body.acl = PVector.sub(body2.pos, body.pos);
          body.acl.setMag(GRAVITY * body2.mass*body.pos.dist(body2.pos));
        }
      }   
    }
  }
  
  void draw() {
    for (CelestialBody body : bodies) {
      body.draw();
    }
  }
}

GameManager game = new GameManager();

long t;

void setup() {
  background(0);
  noStroke();
  smooth();
  
  ellipseMode(RADIUS);
  t = System.nanoTime();
  
  size(800, 600);
  
  Star star = new Star(new PVector(width/2, height/2), new PVector(0,0), 
                     500000000, 30, color(255,255,255));
                     
  Planet planet1 = new Planet(new PVector(100,100), new PVector(5000,100),
                            100, 10, color(255, 0, 0));
  
  game.addBody(star);
  game.addBody(planet1);

}

void draw() { 
  clear();
  long ct = System.nanoTime();
  float dt = (ct - t) / 1000000000.0;
  t = ct;
  
  game.update(dt);
  game.draw(); 
}