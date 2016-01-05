/*TODO: planet collisions?
        customiztion of planets
        user input panel
        mouse throw initial velocity
        acceleration calculation
        resolve collisions with dpos
        select and delete planet
        Calculate correct gravity
        check drawpath boolean
*/

abstract class CelestialBody {
  PVector vel; //velocity
  PVector acl = new PVector(0,0); //acceleration
  PVector pos; //position
  PVector dpos = new PVector(0,0); //change in position to next frame: delta pos
  double mass;
  float radius;
  color col;
  int pathLength = 500;
  ArrayList<PVector> path;
  
  CelestialBody(PVector ipos, PVector ivel, 
                double imass, float iradius, color icol) {       
    pos = ipos;
    vel = ivel;
    mass = imass;
    radius = iradius;
    col = icol;
    path = new ArrayList<PVector>();
  }
  
  void move(float dt) {
    acl.div((float)1e14);
    vel.add(PVector.mult(acl,dt));
    dpos = PVector.mult(vel, dt).add(PVector.mult(acl,0.5*dt*dt));
    pos.add(dpos);
    
    path.add(new PVector(pos.x, pos.y));
    
    if (path.size() > pathLength) {
      path.remove(0);      
    }
  }
  
  void draw() {
    fill(col);
    stroke(col);
    ellipse(pos.x, pos.y, radius, radius);
    for (int i = 1; i < path.size(); ++i) {
      PVector p1 = path.get(i);
      PVector p2 = path.get(i-1);
      line(p1.x, p1.y, p2.x, p2.y);
    }
  }
  
  void intersect() {
    
  }
  
  void collide() {
    
  }
}

class Planet extends CelestialBody {
  
  Planet(PVector ipos, PVector ivel, double imass,
         float iradius, color icol) {
    super(ipos, ivel, imass, iradius, icol);
  }
  
  void move(float dt) {
    super.move(dt);
  }
  
}

class Star extends CelestialBody {
  Star(PVector ipos, PVector ivel, double imass,
         float iradius, color icol) {
    super(ipos, ivel, imass, iradius, icol);
  }
}
class UserInterface {
  //Initial Values For planet spawning/UI
  int planetXvel= 25;
  int planetYvel = 25;
  int planetMass = 500;
  int planetRadius = 10;
  int planetRed = 0;
  int planetGreen = 0;
  int planetBlue = 255;

  boolean help = false;
  UserInterface() {
    
  }
  void draw(int planetCounter, int planetLimit, CelestialBody body) {
    int textShift = 160;
    int helpTextShift = 280;
    fill(255);
    textAlign(LEFT);
    textSize(16);
    text("Planet Details", width-textShift, 20);
    textSize(14);
    text("X Vel:   " + body.vel.x, width-textShift, 35);
    text("Y Vel:   " + body.vel.y, width-textShift, 50); 
    text("Mass:    " + body.mass, width-textShift, 65);
    text("Radius:  " + body.radius, width-textShift, 80);
    text("Red:     " + red(body.col), width-textShift, 95);
    text("Green:   " + green(body.col), width-textShift, 110);
    text("Blue:    " + blue(body.col), width-textShift, 125);
    text("Preview: ", width-textShift, 140);
    noStroke();
    fill(body.col);
    ellipse(width-80,150+body.radius, body.radius, body.radius);
    fill(255);
    text("Planet Num:   " + planetCounter, width-textShift, 170+body.radius*2);
    text("Planet Limit: " + planetLimit, width-textShift, 185+body.radius*2);
    text("Press '1' for help", width-textShift, 200+body.radius*2);
    fill(color(255,0,0));
    if (help) { //Display Help
      fill(color(255,0,0));
      text("Click to place a planet", width-helpTextShift, 215+planetRadius*2);
      text("| ADD | SUB |", width-helpTextShift, 20);
      text("| 'q' | 'a' |", width-helpTextShift, 35);
      text("| 'w' | 's' |", width-helpTextShift, 50);
      text("| 'e' | 'd' |", width-helpTextShift, 65);
      text("| 'r' | 'f' |", width-helpTextShift, 80);
      text("| 't' | 'g' |", width-helpTextShift, 95);
      text("| 'y' | 'h' |", width-helpTextShift, 110);
      text("| 'u' | 'j' |", width-helpTextShift, 125);
      text("-------------", width-helpTextShift, 140);
      text("'ESC' = Exit", width-helpTextShift, 155);
      text("'p' =  Pause", width-helpTextShift, 170);
      text("'l' =  Lines", width-helpTextShift, 185);
    }
  }
    
}
class GameManager {
  int framerate = 60;
  boolean paused = false;
  int gameWidth = width-200;
  int gameHeight = 600;
  final float GRAVITY = 6.67e-11;
  int planetLimit = 25;
  UserInterface UI;
  CelestialBody selectedBody;
  
  ArrayList<CelestialBody> bodies = new ArrayList<CelestialBody>(); 

  GameManager(UserInterface _ui, ArrayList<CelestialBody> initialBodies) {
    UI = _ui;
    for (CelestialBody body : initialBodies)
      addBody(body);
      
    selectedBody = bodies.get(0);
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
  
  void createPlanet()
  {
    if (bodies.size() < planetLimit) {
      Planet planet = new Planet(new PVector(mouseX,mouseY), new PVector(UI.planetXvel,UI.planetYvel),
                            UI.planetMass, UI.planetRadius, color(UI.planetRed, UI.planetGreen, UI.planetBlue));
      game.addBody(planet);
      selectedBody = planet;
    }
  }
  
  void update(float dt) {
    for (CelestialBody body : bodies) {      
      body.move(dt);
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
    for (CelestialBody body : bodies) {
      for (CelestialBody body2 : bodies) {
        if (body != body2) {
          float dist = body.pos.dist(body2.pos);
          if (dist < body.radius+body2.radius) {
            //println("colliding");
          }
        }      
      }
    }
  }
  
  void draw() {
    UI.draw(bodies.size(), planetLimit, selectedBody);
    for (CelestialBody body : bodies) {
      body.draw();
    }
  }
}

UserInterface UI = new UserInterface();
//maybe add some initial planets/stars?
ArrayList<CelestialBody> intialBodies;

GameManager game;

long t;
boolean paused = false;
boolean drawPath = false;

void setup() {
  noStroke();
  PFont fixedWidthFont = createFont("Courier New", 12);
  textFont(fixedWidthFont);
  background(0);
  smooth();

  ellipseMode(RADIUS);
  t = System.nanoTime();
  
  size(1000, 600);
  
  Star star = new Star(new PVector(width/2, height/2), new PVector(0,0), 
                     2e30, 30, color(255,255,255));
                     
  intialBodies = new ArrayList<CelestialBody>();
  intialBodies.add(star);
                     
  game = new GameManager(UI, intialBodies);
}

void draw() { 
  clear();
  long ct = System.nanoTime();
  float dt = (ct - t) / 1000000000.0;
  t = ct;
  if (!paused) {
    game.update(dt);
    game.collide();
    game.cleanUp();
  } else {
    fill(255);
    textSize(25);
    text("PAUSED", width/2, 30);
  }
  game.draw(); 
}

void mouseClicked() {
  game.createPlanet();
}
void keyPressed() {
  if (key == 'p') {
    paused = !paused;
  } else if (key == ESC) {
    exit();
  } else if (key == 'l') {
    drawPath = !drawPath; //Doesnt do anything yet
  } else if (key == '1') {
    UI.help = !UI.help;
  }
  CelestialBody body = game.selectedBody;
  //Change Planet Params
  if (key == 'q') {
    body.vel.x +=5;
  } else if (key == 'a') {
    body.vel.x -=5;
  } else if (key == 'w') {
    body.vel.y +=5;
  } else if (key == 's') {
    body.vel.y -=5;
  } else if (key == 'e') {
    body.mass +=5;
  } else if (key == 'd') {
    if (body.mass > 5) {
      body.mass -=5;
    }
  } else if (key == 'r') {
    body.radius +=5;
  } else if (key == 'f') {
    if (body.radius > 2) {
      body.radius -=2;
    }
  } else if (key == 't') {
    if (red(body.col)<255) {
      //to do
    }
  } else if (key == 'g') {
    if (red(body.col)>1) {
      //todo
    }
  } else if (key == 'y') {
    if (green(body.col)<255) {
      ;//todo
    }
  } else if (key == 'h') {
    if (green(body.col)>1) {
      //todo
    }
  } else if (key == 'u') {
    if (blue(body.col)<255) {
      //todo
    }
  } else if (key == 'j') {
    if (blue(body.col)>1) {
      //todo
    }
  }
  
}