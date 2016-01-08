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
      UI.planetYvel -= 2;
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
     if (UI.planetRadius < 80) { 
        UI.planetRadius -= 2;
      }
      break;
    case 'f':
      if (UI.planetRadius > 2) { 
        UI.planetRadius -= 2;
      }
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
        UI.planetGreen -= 2;
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
    case 'z':
      debug = !debug;
      break;
    case 'i':
      if (game.simulationSpeed < 8)
        game.simulationSpeed *= 2;
      break;
    case 'k':
      game.simulationSpeed /= 2;
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
    