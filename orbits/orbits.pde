/*TODO: 
        mouse throw initial velocity
        write help.txt
        Add gamesimspeed to help and regular UI
*/

void resetBoard() {
  game.bodies.clear();
  UI.reset();
  setup();
}

UserInterface UI;
GameManager game;

long t;
boolean debug = false;

void setup() {
  PFont fixedWidthFont = createFont("Courier New", 12);
  textFont(fixedWidthFont);
  background(0);
  noStroke();
  smooth();
  ellipseMode(RADIUS);
  t = System.nanoTime();
  
  String help[] = loadStrings("help.txt");
  
  UI = new UserInterface(help);
  game = new GameManager(UI);

  size(1000, 600);

  Star star = new Star(new PVector(width/2, height/2), new PVector(0,0),
                     (float)2e30, 30, color(255,255,255));

  game.addBody(star);
}
int frame = 0;
float fps = 0.0;

void draw() {
  clear();
  long ct = System.nanoTime();
  float dt = (ct - t) / 1000000000.0;
  if (debug) {
    if (frame == 20) { //sample only every 20 frames 
      fps = 1/dt;
      fill(255);
      frame = 0;
    }
    textSize(30);
    text(String.format("FPS: %.2f",fps), 0, 30);
    frame++;
  }
  t = ct;
  if (!game.paused) {
    game.update(dt);
    game.cleanUp();
  }
  game.draw();
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
  //Spawn Normally
  if (!noSpawn) { //not selecting planet

    game.addBody(new Planet(new PVector(mouseX, mouseY), new PVector(UI.planetXvel,UI.planetYvel),
                        (float)UI.planetMass, UI.planetRadius, color(UI.planetRed, UI.planetGreen, UI.planetBlue)));
    UI.randomizeColor();
  }
  noSpawn = false;
}
void mouseDragged() {
  if (UI.planetSelected) {
    game.selected.vel.add(new PVector(mouseX - pmouseX, mouseY - pmouseY)); 
  } else {
    UI.planetXvel += mouseX - pmouseX;
    UI.planetYvel += mouseY - pmouseY;
  }
  game.dragged = true;
  
  if (game.drawFun) {
    game.addBody(new Planet(new PVector(mouseX, mouseY), new PVector(UI.planetXvel,UI.planetYvel),
                         (float)UI.planetMass, UI.planetRadius, color(UI.planetRed, UI.planetGreen, UI.planetBlue)));
    UI.randomizeColor();
          
    UI.planetXvel = 0;
    UI.planetYvel = 0;
    
  }
    
}

void mouseReleased() { 
  if (!UI.planetSelected && game.dragged) {
    game.addBody(new Planet(new PVector(mouseX, mouseY), new PVector(UI.planetXvel,UI.planetYvel),
                         (float)UI.planetMass, UI.planetRadius, color(UI.planetRed, UI.planetGreen, UI.planetBlue)));
    UI.randomizeColor();
    
    UI.planetXvel = 24;
    UI.planetYvel = 24;
    game.dragged = false;
  }
}