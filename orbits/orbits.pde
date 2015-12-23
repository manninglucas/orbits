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
  long mass;
  float radius;
  color col;
  int pathLength = 500;
  ArrayList<PVector> path;
  
  CelestialBody(PVector ipos, PVector ivel, 
                long imass, float iradius, color icol) {       
    pos = ipos;
    vel = ivel;
    mass = imass;
    radius = iradius;
    col = icol;
    path = new ArrayList<PVector>();
  }
  
  void move(float dt) {
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
  
  Planet(PVector ipos, PVector ivel, long imass,
         float iradius, color icol) {
    super(ipos, ivel, imass, iradius, icol);
  }
  
  void move(float dt) {
    super.move(dt);
  }
  
}

class Star extends CelestialBody {
  Star(PVector ipos, PVector ivel, long imass,
         float iradius, color icol) {
    super(ipos, ivel, imass, iradius, icol);
  }
}
class UserInterface {
  //Initial Values For planet spawning/UI
  int planetCounter = 0;
  int planetXvel= 25;
  int planetYvel = 25;
  int planetMass = 500;
  int planetRadius = 10;
  int planetRed = 0;
  int planetGreen = 0;
  int planetBlue = 255;
  int planetLimit = 25;
  boolean help = false;
  UserInterface() {
    
  }
  void draw() {
    int textShift = 160;
    int helpTextShift = 280;
    fill(255);
    textAlign(LEFT);
    textSize(16);
    text("Planet Details", width-textShift, 20);
    textSize(14);
    text("X Vel:   " + planetXvel, width-textShift, 35);
    text("Y Vel:   " + planetYvel, width-textShift, 50); 
    text("Mass:    " + planetMass, width-textShift, 65);
    text("Radius:  " + planetRadius, width-textShift, 80);
    text("Red:     " + planetRed, width-textShift, 95);
    text("Green:   " + planetGreen, width-textShift, 110);
    text("Blue:    " + planetBlue, width-textShift, 125);
    text("Preview: ", width-textShift, 140);
    fill(color(planetRed, planetGreen, planetBlue));
    ellipse(width-80,150+planetRadius, planetRadius, planetRadius);
    fill(255);
    text("Planet Num:   " + planetCounter, width-textShift, 170+planetRadius*2);
    text("Planet Limit: " + planetLimit, width-textShift, 185+planetRadius*2);
    text("Press '1' for help", width-textShift, 200+planetRadius*2);
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
  final float GRAVITY = .001;
  
  ArrayList<CelestialBody> bodies = new ArrayList<CelestialBody>(); 

  GameManager() {
    
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
    for (CelestialBody body : bodies) {
      body.draw();
    }
  }
}

GameManager game = new GameManager();
UserInterface UI = new UserInterface();
Planet[] planets;
long t;
boolean paused = false;
boolean drawPath = false;

void setup() {
  PFont fixedWidthFont = createFont("Courier New", 12);
  textFont(fixedWidthFont);
  background(0);
  noStroke();
  smooth();
  planets = new Planet[UI.planetLimit];

  ellipseMode(RADIUS);
  t = System.nanoTime();
  
  size(1000, 600);
  
  Star star = new Star(new PVector(width/2, height/2), new PVector(0,0), 
                     500000000, 30, color(255,255,255));

  game.addBody(star);
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
  UI.draw();
}

void mouseClicked() {
  if (UI.planetCounter<UI.planetLimit) {
    planets[UI.planetCounter] = new Planet(new PVector(mouseX,mouseY), new PVector(UI.planetXvel,UI.planetYvel),
                          UI.planetMass, UI.planetRadius, color(UI.planetRed, UI.planetGreen, UI.planetBlue));
    game.addBody(planets[UI.planetCounter]);  
    UI.planetCounter++;
  }
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
  //Change Planet Params
  if (key == 'q') {
    UI.planetXvel+=5;
  } else if (key == 'a') {
    UI.planetXvel-=5;
  } else if (key == 'w') {
    UI.planetYvel+=2;
  } else if (key == 's') {
    UI.planetYvel-=2;
  } else if (key == 'e') {
    UI.planetMass+=5;
  } else if (key == 'd') {
    if (UI.planetRadius > 0) {
      UI.planetMass-=5;
    }
  } else if (key == 'r') {
    UI.planetRadius+=2;
  } else if (key == 'f') {
    if (UI.planetRadius > 0) {
      UI.planetRadius-=2;
    }
  } else if (key == 't') {
    if (UI.planetRed<255) {
      UI.planetRed+=2;
    }
  } else if (key == 'g') {
    if (UI.planetRed>1) {
      UI.planetRed-=2;
    }
  } else if (key == 'y') {
    if (UI.planetGreen<255) {
      UI.planetGreen+=2;
    }
  } else if (key == 'h') {
    if (UI.planetGreen>1) {
      UI.planetGreen-=2;
    }
  } else if (key == 'u') {
    if (UI.planetBlue<255) {
      UI.planetBlue+=2;
    }
  } else if (key == 'j') {
    if (UI.planetBlue>1) {
      UI.planetBlue-=2;
    }
  }
  
}