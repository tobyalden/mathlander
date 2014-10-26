// Size of individual cells, in pixels
final int CELL_SIZE = 10;
// Size of total map, in cells
final int MAP_WIDTH = 64;
final int MAP_HEIGHT = 48;
// Size of the game window, in pixels
final int WINDOW_WIDTH = CELL_SIZE * MAP_WIDTH;
final int WINDOW_HEIGHT = CELL_SIZE * MAP_HEIGHT;

final int CELL_FLOOR = 0;
final int CELL_WALL = 1;

final float FILL_PERCENT = 0.33;

final int NUMBER_OF_STEPS = round(MAP_WIDTH * MAP_HEIGHT * FILL_PERCENT);

int map[][];

void setup()
{
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  generateMap_DrunkardsWalk();
}

void generateMap_DrunkardsWalk()
{
  
  int numberOfSteps = NUMBER_OF_STEPS;
  
  // initialize all map cells to walls
  map = new int[MAP_WIDTH][MAP_HEIGHT];
  for (int x = 0; x <= MAP_WIDTH - 1; x++) {
    for (int y = 0; y <= MAP_HEIGHT - 1; y++) {
      map[x][y] = CELL_WALL;
    }
  }

  // pick a map cell as the starting point
  PVector drunkard = new PVector(round(MAP_WIDTH/4), round(MAP_HEIGHT/4));
  
  // turn the selected map cell into floor
  map[int(drunkard.x)][int(drunkard.y)] = CELL_FLOOR;
  
  // while insufficient cells have been turned into floor
  while(numberOfSteps > 0)
  {
    // take one step in a random direction
    float direction = random(1);
    if(direction < 0.25 && drunkard.x + 1 < MAP_WIDTH)
    {
       drunkard.x += 1; 
    }
    else if(direction < 0.5 && direction > 0.25 && drunkard.y + 1 < MAP_HEIGHT)
    {
       drunkard.y += 1; 
    }
    else if(direction < 0.75 && direction > 0.5 && drunkard.x - 1 >= 0)
    {
       drunkard.x -= 1; 
    }
    else if(direction > 0.75 && drunkard.y - 1 >= 0)
    {
       drunkard.y -= 1; 
    }
    
    // if the new map cell is wall
    if(map[int(drunkard.x)][int(drunkard.y)] == CELL_WALL)
    {
       map[int(drunkard.x)][int(drunkard.y)] = CELL_FLOOR;
       numberOfSteps--; 
    }
  }
  
}

void iterateAutomata() {
  println("iterating...");
  for (int x = 0; x <= MAP_WIDTH - 1; x++) {
    for (int y = 0; y <= MAP_HEIGHT - 1; y++) {
      int adjCount = countSurroundingSolids(x, y, 1);
      if (adjCount >= 5) {
        map[x][y] = CELL_FLOOR;
      }
      else {
        map[x][y] = CELL_WALL;
      }
    }
  }
}

// inclusive
int countSurroundingSolids(int x, int y, int radius) {
  int solidCount = 0;
  for (int xScan = x - radius; xScan <= x + radius; xScan++) {
    if (xScan > 0 && xScan <= MAP_WIDTH - 1) {
      for (int yScan = y - radius; yScan <= y + radius; yScan++) {
        if (yScan > 0 && yScan <= MAP_HEIGHT - 1) {
          if (!(map[xScan][yScan] == CELL_WALL)) {
            solidCount++;
          }
        }
      }
    }
  }
  return solidCount;
}

void draw()
{
  for (int x = 0; x <= MAP_WIDTH - 1; x++) {
    for (int y = 0; y <= MAP_HEIGHT - 1; y++) {
      if (map[x][y] == CELL_FLOOR)
      {
        fill(0);
      } else if (map[x][y] == CELL_WALL)
      {
        fill(255);
      }
      rect(x*CELL_SIZE, y*CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
  }
}

void keyPressed() {
  if (key == 'g' || key == 'G') {
    generateMap_DrunkardsWalk();
  }
  else if (key == 'i' || key == 'I') {
    iterateAutomata();
  }
}

