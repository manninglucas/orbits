//Orbits
//
//by Braeden Smith and Lucas Manning

UserInterface UI;
GameManager game;

void resetBoard() {
  game.bodies.clear();
  UI.reset();
  setup();
}

void setup() {
  //draw setups
  PFont fixedWidthFont = createFont("Courier New", 12);
  textFont(fixedWidthFont);
  background(0);
  noStroke();
  smooth();
  ellipseMode(RADIUS);
  t = System.nanoTime();
 
  //loads help string from file for UI
  String help[] = loadStrings("help.txt");
  
  UI = new UserInterface(help);
  game = new GameManager(UI);

  fullScreen();

  //creates a star in the center of the screen
  CelestialBody star = new CelestialBody(new PVector(width/2, height/2),
                    new PVector(0,0), (float)2e30, 30, color(255,255,255));

  game.bodies.add(star);
}

//variables for calculating fps and physics speed
long t;
int frame = 0;
float fps = 0.0;

void draw() {
  clear();

  //calculates current time and amount of time between frames
  long ct = System.nanoTime();
  float dt = (ct - t) / 1000000000.0;
  t = ct;

  if (game.debug) {
    if (frame == 20) { //sample only every 20 frames 
      fps = 1/dt;
      fill(255);
      frame = 0;
    }
    textSize(30);
    text(String.format("FPS: %.2f",fps), 0, 30);
    frame++;
  }

  if (!game.paused) {
    game.update(dt);
    game.cleanUp();
  }
  game.draw();
}

//with no mouse drag, create a planet with set vel vars
void mouseClicked() {
  //no spawn checks if planet is selected
  boolean noSpawn = false;

  //Incase it moves while iterating
  int mosX = mouseX; 
  int mosY = mouseY;
    
  //Checks if mouse is touching the planet (square shaped though)
  for (int i = 0; i < game.bodies.size(); i++) {
      CelestialBody body = game.bodies.get(i);

      float xPos = body.pos.x;
      float yPos = body.pos.y;
      float rad = body.radius;

      if (mosX >= xPos-rad && mosX <= xPos+rad 
            && mosY >= yPos-rad && mosY <= yPos+rad) {
        game.selected = body;
        UI.selectPlanetLoad(game.selected);
        noSpawn = true;
      }
  }

  if (UI.planetSelected && UI.planetMove) { //User want to change planet location
    game.selected.pos = new PVector(mouseX, mouseY); //Change body's pos
    noSpawn = true;
    game.selected.path.clear(); //Remove path on move
  }

  //not selecting planet place planet normally
  if (!noSpawn) { 
    game.bodies.add(new CelestialBody(new PVector(mouseX, mouseY), 
         new PVector(UI.planetXvel,UI.planetYvel),
        (float)UI.planetMass, UI.planetRadius, 
        color(UI.planetRed, UI.planetGreen, UI.planetBlue)));

    UI.randomizeColor();
  }
  noSpawn = false;
}

//create a planet with vel proportional to distance dragged
void mouseDragged() {
  //adds vel to a selected planet or changes the UI vel based on the drag
  if (UI.planetSelected) {
    game.selected.vel.add(new PVector(mouseX - pmouseX, mouseY - pmouseY)); 
  } else {
    UI.planetXvel += mouseX - pmouseX;
    UI.planetYvel += mouseY - pmouseY;
  }
  game.mouseDragged = true;
 
  //shhh. this is a secret variable that allow a special draw mode  
  if (game.drawFun) {
    game.bodies.add(new CelestialBody(new PVector(mouseX, mouseY), 
        new PVector(UI.planetXvel,UI.planetYvel),
        (float)UI.planetMass, UI.planetRadius, 
        color(UI.planetRed, UI.planetGreen, UI.planetBlue)));

    UI.randomizeColor();
          
    UI.planetXvel = 0;
    UI.planetYvel = 0;
    
  } 
}

//this will finally creates a planet after it was dragged
void mouseReleased() { 
  if (!UI.planetSelected && game.mouseDragged) {
    game.bodies.add(new CelestialBody(new PVector(mouseX, mouseY), 
            new PVector(UI.planetXvel,UI.planetYvel),
            (float)UI.planetMass, UI.planetRadius, 
            color(UI.planetRed, UI.planetGreen, UI.planetBlue)));

    UI.randomizeColor();
    
    UI.planetXvel = 24;
    UI.planetYvel = 24;
    game.mouseDragged = false;
  }
}