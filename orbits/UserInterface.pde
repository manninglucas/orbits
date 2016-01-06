class UserInterface {
  //Initial Values For planet spawning/UI
  int planetXvel= 24;
  int planetYvel = 24;
  double planetMass = 6e24;
  int planetRadius = 10;
  int planetRed = int(random(0,255));
  int planetGreen = int(random(0,255));
  int planetBlue = int(random(0,255));
  boolean planetSelected = false;
  boolean planetMove = false;
  boolean help = false;
  boolean drawPath = true;

  UserInterface() {}

  void draw(boolean paused, int bodyCount, CelestialBody selected) {
    fill(0);
    noStroke();
    rect(width-160,0,300,185+planetRadius*2+16);
    if (planetSelected) { //If a planet is selected, update its attributes in draw
      selectPlanetLoad(selected);
    }
    if (paused) {
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
      text("Bodies: " + bodyCount, width-textShift, 170+planetRadius*2);
    }
    text("Press '1' for help", width-textShift, 185+planetRadius*2);

    if (help) { //Display Help
      fill(0);
      noStroke();
      rect(width-280,0,120,200+planetRadius*2+16);
      rect(width-280,185+planetRadius*2+16,300,60);
      fill(255);
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
      text("'z' = debug", width-helpTextShift, 215);
      text("'SPACE' = Reset board", width-helpTextShift, 230+planetRadius*2);
      text("Click to place a planet", width-helpTextShift, 245+planetRadius*2);
      text("Click on planet to modify", width-helpTextShift, 260+planetRadius*2);
      if (planetSelected) {
        fill(255);
        text("'BACKSPACE' = Delete planet", width-helpTextShift, 275+planetRadius*2);
        text("'ENTER' =  Deselect planet", width-helpTextShift, 290+planetRadius*2);
        text("'m' =  Toggle move planet with mouse", width-helpTextShift, 305+planetRadius*2);
      }
    }
  }

  void selectPlanetLoad(CelestialBody body) {
    //Load in values to UI
    //Used for updating UI too
    planetSelected = true;
    planetXvel = int(body.vel.x);
    planetYvel = int(body.vel.y);
    planetMass = body.mass;
    planetRadius = int(body.radius);
    planetRed = int(red(body.col));
    planetGreen = int(green(body.col));
    planetBlue = int(blue(body.col));
  }

  void selectPlanetChange(CelestialBody body) {
    //Change the values of the planet based on keyboard input (param change)
    body.vel = new PVector(planetXvel, planetYvel);
    body.mass = (float)planetMass;
    body.radius = planetRadius;
    body.col = color(planetRed, planetGreen, planetBlue);
  }
  void reset() {
    //reset to default UI values
    planetXvel= 25;
    planetYvel = 25;
    planetMass = 6e24;
    planetRadius = 10;
    planetRed = int(random(0,255));
    planetGreen = int(random(0,255));
    planetBlue = int(random(0,255));
  }
}