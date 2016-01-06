/*TODO: planet collisions?
        mouse throw initial velocity
        acceleration calculation
        resolve collisions with dpos
        Calculate correct gravity
        Have the option to chnage speed
*/

void resetBoard() {
  game.bodies.clear();
  UI.reset();
  setup();
}

UserInterface UI;
GameManager game;

long t;


void setup() {
  PFont fixedWidthFont = createFont("Courier New", 12);
  textFont(fixedWidthFont);
  background(0);
  noStroke();
  smooth();
  ellipseMode(RADIUS);
  t = System.nanoTime();
  
  UI = new UserInterface();
  game = new GameManager(UI);

  size(1000, 600);

  Star star = new Star(new PVector(width/2, height/2), new PVector(0,0),
                     (float)2e30, 30, color(255,255,255));

  game.addBody(star);
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
    game.selected.path.clear(); //Make this remove whole path, don't know how to delete all arraylist
  }

  //Spawn Normally
  if (!noSpawn) { //not selecting planet
    game.addBody(new Planet(new PVector(mouseX, mouseY), new PVector(UI.planetXvel,UI.planetYvel),
                        UI.planetMass, UI.planetRadius, color(UI.planetRed, UI.planetGreen, UI.planetBlue)));
    UI.planetRed = int(random(0,255));
    UI.planetGreen = int(random(0,255));
    UI.planetBlue = int(random(0,255));
  }
  noSpawn = false;
}

void keyPressed() {
  switch(key) {
    case 'p':
      game.paused = !game.paused;
      break;
    case ESC:
      exit();
      break;
    case 'l':
      UI.drawPath = !UI.drawPath;
      break;
    case '1':
      UI.help = !UI.help;
      break;
    case 'o':
      UI.reset();
      break;
    case ' ':
      resetBoard();
      break;
    case 'q':
      UI.planetXvel += 2;
      break;
    case 'a':
      UI.planetXvel -= 2;
      break;
    case 'w':
      UI.planetYvel += 2;
      break;
    case 's':
      UI.planetYvel += 2;
      break;
    case 'e':
      UI.planetMass += 100;
      break;
    case 'd':
      if (UI.planetMass > 0) {
        UI.planetMass-=100;
      } 
      break;
    case 'r':
      UI.planetRadius += 2;
      break;
    case 't':
      if (UI.planetRed < 255) {
        UI.planetRed += 2;
      } 
      break;
    case 'g':
      if (UI.planetRed > 1) {
        UI.planetRed -= 2;
      } 
      break;
    case 'y':
      if (UI.planetGreen < 255) {
        UI.planetGreen += 2;
      } 
      break;
    case 'h':
      if (UI.planetGreen > 1) {
        UI.planetBlue -= 2;
      } 
      break;
    case 'u':
      if (UI.planetBlue < 255) {
        UI.planetBlue += 2;
      } 
      break;
    case 'j':
      if (UI.planetBlue > 1) {
        UI.planetBlue -= 2;
      } 
      break;
  }
  if (UI.planetSelected) {
    UI.selectPlanetChange(game.selected); //Update the planet when any keys are presses
    if (key == BACKSPACE) {
      //Delete planet
      game.removeBody(game.selected);
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
    