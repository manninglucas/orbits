/*TODO: planet collisions?
        customiztion of planets
        user input panel
        mouse throw initial velocity
*/
abstract class CelestialBody {
  float vx;
  float vy;
  float ax = 0;
  float ay = 0;
  int x;
  int y;
  long mass;
  float radius;
  color col;
  
  CelestialBody(int ix, int iy, float ivx, float ivy, 
                long imass, float iradius, color icol) {       
    x = ix;
    y = iy;
    vx = ivx;
    vy = ivy;
    mass = imass;
    radius = iradius;
    col = icol;
  }
  
  void move() {   
  }
  
  void draw() {
    fill(col);
    ellipse(float(x), float(y), radius, radius);
  }
  
  void intersect() {
    
  }
  
  void collide() {
    
  }
}

class Planet extends CelestialBody {
  
  Planet(int ix, int iy, float ivx, float ivy,
         long imass, float iradius, color icol) {
    super(ix, iy, ivx, ivy, imass, iradius, icol);
  }
  
}

class Star extends CelestialBody {
  Star(int ix, int iy, float ivx, float ivy,
       long imass, float iradius, color icol) {       
    super(ix, iy, ivx, ivy, imass, iradius, icol);
   }
}

class GameManager {
  int framerate = 60;
  boolean paused = false;
  int gameWidth = 800;
  int gameHeight = 600;
  final int GRAVITY = 1;
  
  ArrayList<CelestialBody> bodies = new ArrayList<CelestialBody>(); 

  GameManager() {
    
  }
  
  void addBody(CelestialBody body) {
    bodies.add(body);
  }
  
  void draw() {
    for (CelestialBody body : bodies) {
      body.draw();
    }
  }
}

GameManager game = new GameManager();

long t;
int width = game.gameWidth;
int height = game.gameHeight;

Star star = new Star(width/2, height/2, 0, 0, 500000000, 30, color(255,255,255));
Planet planet1 = new Planet(100, 100, 0, 0, 100, 10, color(255, 0, 0));

void setup() {
  background(0);
  noStroke();
  smooth();
  
  ellipseMode(RADIUS);
  t = System.nanoTime();
  
  size(800, 600);
  
  game.addBody(star);
  game.addBody(planet1);

}

void draw() { 
  long ct = System.nanoTime();
  float dt = (ct - t) / 1000000000.0;
  t = ct;
  
  game.draw();
  
}