/*TODO: planet collisions?
        mouse throw initial velocity
        acceleration calculation
        resolve collisions with dpos
        Calculate correct gravity
        Have the option to chnage speed
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
    if (drawPath) {
      for (int i = 1; i < path.size(); ++i) {
        PVector p1 = path.get(i);
        PVector p2 = path.get(i-1);
        line(p1.x, p1.y, p2.x, p2.y);
      }
    }
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
  int bodyCounter;
  int planetXvel= 24;
  int planetYvel = 24;
  int planetMass = 500;
  int planetRadius = 10;
  int planetRed = int(random(0,255));
  int planetGreen = int(random(0,255));
  int planetBlue = int(random(0,255));
  boolean planetSelected = false;
  boolean planetMove = false;
  boolean help = false;
  CelestialBody body; //Selected body

  UserInterface() {}

  void draw() {
    if (planetSelected) { //If a planet is selected, update its attributes in draw
      selectPlanetLoad();
    }
    if (game.paused) {
      fill(255);
      textSize(25);
      text("PAUSED", width/2-50, 30);
    }
    if (planetMove) {
      fill(0,255,0);
      textSize(25);
      text("MOVING", width/2-50, 50);
    }
    //Planet Details
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
    stroke(color(planetRed, planetGreen, planetBlue));
    ellipse(width-80,150+planetRadius, planetRadius, planetRadius);
    fill(255);
    if (planetSelected) {
      fill(0,255,0);
      text("Planet Selected", width-textShift, 170+planetRadius*2);
      fill(255);
    } else {
      text("Bodies: " + bodyCounter, width-textShift, 170+planetRadius*2);
    }
    text("Press '1' for help", width-textShift, 185+planetRadius*2);
    fill(color(255,0,0));

    if (help) { //Display Help
      fill(color(255,0,0));
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
      text("'o' = Reset #", width-helpTextShift, 200);
      text("'SPACE' = Reset board", width-helpTextShift, 215+planetRadius*2);
      text("Click to place a planet", width-helpTextShift, 230+planetRadius*2);
      text("Click on planet to modify", width-helpTextShift, 245+planetRadius*2);
      if (planetSelected) {
        fill(0,255,0);
        text("'BACKSPACE' = Delete planet", width-helpTextShift, 260+planetRadius*2);
        text("'ENTER' =  Deselect planet", width-helpTextShift, 275+planetRadius*2);
        text("'m' =  Toggle move planet with mouse", width-helpTextShift, 290+planetRadius*2);
        fill(255);
      }
    }
  }

  void selectPlanetLoad() {
    //Load in values to UI
    //Used for updating UI too
    planetSelected = true;
    planetXvel = int(body.vel.x);
    planetYvel = int(body.vel.y);
    planetMass = int(body.mass);
    planetRadius = int(body.radius);
    planetRed = int(red(body.col));
    planetGreen = int(green(body.col));
    planetBlue = int(blue(body.col));
  }

  void selectPlanetChange() {
    //Change the values of the planet based on keyboard input (param change)
    body.vel = new PVector(planetXvel, planetYvel);
    body.mass = planetMass;
    body.radius = planetRadius;
    body.col = color(planetRed, planetGreen, planetBlue);
  }
  void reset() {
    //reset to default UI values
    planetXvel= 25;
    planetYvel = 25;
    planetMass = 500;
    planetRadius = 10;
    planetRed = int(random(0,255));
    planetGreen = int(random(0,255));
    planetBlue = int(random(0,255));
  }

  void countBodies() {
    bodyCounter = game.bodies.size();
  }
}
class GameManager {
  int framerate = 60;
  boolean paused = false;
  int gameWidth = width-200;
  int gameHeight = 600;
  final float GRAVITY = .001;
  ArrayList<CelestialBody> bodies = new ArrayList<CelestialBody>();

  GameManager() {}

  void addBody(CelestialBody body) {
    bodies.add(body);
  }

  void cleanUp() {
    for (int i = 0; i < bodies.size(); i++) {
      CelestialBody body = bodies.get(i);
      PVector center = new PVector(width/2, height/2);
      if (body.pos.dist(center) > 5000) {
        bodies.remove(i);
        UI.countBodies();
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

  void draw() {
    for (CelestialBody body : bodies) {
      body.draw();
    }
  }
}

void resetBoard() {
  game.bodies.clear();
  UI.reset();
  setup();
}
GameManager game = new GameManager();
UserInterface UI = new UserInterface();
long t;
boolean drawPath = true;

void setup() {
  PFont fixedWidthFont = createFont("Courier New", 12);
  textFont(fixedWidthFont);
  background(0);
  noStroke();
  smooth();
  ellipseMode(RADIUS);
  t = System.nanoTime();

  size(1000, 600);

  Star star = new Star(new PVector(width/2, height/2), new PVector(0,0),
                     500000000, 30, color(255,255,255));

  game.addBody(star);
  UI.countBodies();
}

void draw() {
  clear();
  long ct = System.nanoTime();
  float dt = (ct - t) / 1000000000.0;
  t = ct;
  if (!game.paused) {
    game.update(dt);
    game.collide();
    game.cleanUp();
  }
  game.draw();
  UI.draw();
}

void mouseClicked() {
  boolean noSpawn = false;
  //Check if mouse clicks on planet
  int mosX = mouseX; //Incase it moves while iterating
  int mosY = mouseY;
  for (int i = 0; i < game.bodies.size(); i++) {
      CelestialBody body = game.bodies.get(i);
      float xPos = body.pos.x;
      float yPos = body.pos.y;
      float rad = body.radius;
      //Checks if mouse is touching the planet (square shaped though)
      if (mosX >= xPos-rad && mosX <= xPos+rad && mosY >= yPos-rad && mosY <= yPos+rad) {
        UI.body = body;
        UI.selectPlanetLoad();
        noSpawn = true;
      }
  }

  if (UI.planetSelected && UI.planetMove) { //User want to change planet location
    UI.body.pos = new PVector(mouseX, mouseY); //Change body's pos
    noSpawn = true;
    UI.body.path.clear(); //Make this remove whole path, don't know how to delete all arraylist
  }

  //Spawn Normally
  if (!noSpawn) { //not selecting planet
    game.addBody(new Planet(new PVector(mouseX, mouseY), new PVector(UI.planetXvel,UI.planetYvel),
                        UI.planetMass, UI.planetRadius, color(UI.planetRed, UI.planetGreen, UI.planetBlue)));
    UI.planetRed = int(random(0,255));
    UI.planetGreen = int(random(0,255));
    UI.planetBlue = int(random(0,255));
    UI.countBodies();
  }
  noSpawn = false;
}


void removeBody(CelestialBody body) {
  //Delete a body based on itself not the index
  for (int i = 0; i < game.bodies.size(); i++) {
    CelestialBody body2 = game.bodies.get(i);
    if (body == body2) {
      game.bodies.remove(i);
    }
  }
}
void keyPressed() {
  if (key == 'p') {
    game.paused = !game.paused;
  } else if (key == ESC) {
    exit();
  } else if (key == 'l') {
    drawPath = !drawPath; //Doesnt do anything yet
  } else if (key == '1') {
    UI.help = !UI.help;
  } else if (key == 'o') {
    UI.reset();
  } else if (key == ' ') {
    resetBoard();
  }

  //Change Planet Params
  if (key == 'q') {
    UI.planetXvel+=2;
  } else if (key == 'a') {
    UI.planetXvel-=2;
  } else if (key == 'w') {
    UI.planetYvel+=2;
  } else if (key == 's') {
    UI.planetYvel-=2;
  } else if (key == 'e') {
    UI.planetMass+=100;
  } else if (key == 'd') {
    if (UI.planetMass > 0) {
      UI.planetMass-=100;
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

  if (UI.planetSelected) {
    UI.selectPlanetChange(); //Update the planet when any keys are presses
    if (key == BACKSPACE) {
      //Delete planet
      removeBody(UI.body);
      UI.countBodies();
      UI.planetMove = false;
    } else if (key == ENTER) {
      //Planet done changing
      UI.planetSelected = false;
      UI.planetMove = false;
    } else if (key == 'm') {
      UI.planetMove = !UI.planetMove; //Toggle moving
    }
  }

}