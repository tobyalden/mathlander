// Size of individual cells, in pixels

public static final int CELL_SIZE = 10;
// Size of total map, in cells
public static final int MAP_WIDTH = 64;
public static final int MAP_HEIGHT = 48;

// Size of the game window, in pixels
public static final int WINDOW_WIDTH = CELL_SIZE * MAP_WIDTH;
public static final int WINDOW_HEIGHT = CELL_SIZE * MAP_HEIGHT;


final int CELL_LAND = 0;
final int CELL_OCEAN = 1;
final int CELL_SHORE = 2;


public static final float FILL_PERCENT = 0.33;
public static final int NUMBER_OF_STEPS = round(MAP_WIDTH * MAP_HEIGHT * FILL_PERCENT);

public boolean key_Up, key_Down, key_Left, key_Right = false;


private int map[][];
private Entity player;


void setup()
{
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  frameRate(60);

  player = new Entity(new PVector(0, 0));
  generateMap_DrunkardsWalk();
}

void generateMap_DrunkardsWalk()
{

  int numberOfSteps = NUMBER_OF_STEPS;

  // initialize all map cells to walls
  map = new int[MAP_WIDTH][MAP_HEIGHT];

  for (int x = 0; x <= MAP_WIDTH - 1; x++) {
    for (int y = 0; y <= MAP_HEIGHT - 1; y++) {
      map[x][y] = CELL_OCEAN;
    }
  }

  // pick a map cell as the starting point
  PVector drunkard = new PVector(round(MAP_WIDTH/4), round(MAP_HEIGHT/4));

  // turn the selected map cell into floor

  map[int(drunkard.x)][int(drunkard.y)] = CELL_LAND;


  // while insufficient cells have been turned into floor
  while (numberOfSteps > 0)
  {
    // take one step in a random direction
    float direction = random(1);
    if (direction < 0.25 && drunkard.x + 1 < MAP_WIDTH)
    {
      drunkard.x += 1;
    } else if (direction < 0.5 && direction > 0.25 && drunkard.y + 1 < MAP_HEIGHT)
    {
      drunkard.y += 1;
    } else if (direction < 0.75 && direction > 0.5 && drunkard.x - 1 >= 0)
    {
      drunkard.x -= 1;
    } else if (direction > 0.75 && drunkard.y - 1 >= 0)
    {
      drunkard.y -= 1;
    }

    // if the new map cell is wall

    if (map[int(drunkard.x)][int(drunkard.y)] == CELL_OCEAN)
    {
      map[int(drunkard.x)][int(drunkard.y)] = CELL_LAND;
      numberOfSteps--;
    }
  }
  createShoreline();
}

void iterateAutomata() {
  println("iterating...");
  for (int x = 0; x <= MAP_WIDTH - 1; x++) {
    for (int y = 0; y <= MAP_HEIGHT - 1; y++) {
      int adjCount = countSurroundingSolids(x, y, 1);
      if (adjCount >= 5) {

        map[x][y] = CELL_LAND;
      } else {
        map[x][y] = CELL_OCEAN;
      }

      for (int xScan = -1; xScan <= 1; xScan++) {
        for (int yScan = -1; yScan <= 1; yScan++) {
          if (x + xScan > 0 && x + xScan < MAP_WIDTH && y + yScan > 0 && y + yScan < MAP_HEIGHT && map[x + xScan][y + yScan] == CELL_OCEAN && map[x][y] == CELL_LAND)
            map[x][y] = CELL_SHORE;
        }

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
          if (!(map[xScan][yScan] == CELL_OCEAN)) {
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

  noStroke();
  for (int x = 0; x <= MAP_WIDTH - 1; x++) 
  {
    for (int y = 0; y <= MAP_HEIGHT - 1; y++) 
    {
      if (map[x][y] == CELL_SHORE)
      {
        fill(0,0,255);
      }
      if (map[x][y] == CELL_LAND) 

      {
        fill(0,255,0);
      } else if (map[x][y] == CELL_OCEAN)
      {
        fill(0,51,102);
      }
      rect(x*CELL_SIZE, y*CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
  }

  // update player

  if (key_Up) 
  {
    player.setVelY(player.getVelY() - player.ACCELERATION);
  } 
  else if (key_Down) 
  {
    player.setVelY(player.getVelY() + player.ACCELERATION);
  } 
  else
  {
    if (abs(player.getVelY()) <= player.DECCELERATION)
    {
      player.setVelY(0);
    } 
    else
    {
      player.setVelY(player.getVelY() - player.DECCELERATION * sign(player.getVelY()));
    }
  }

  if (key_Left) 
  {
    player.setVelX(player.getVelX() - player.ACCELERATION);
  } 
  else if (key_Right) 
  {
    player.setVelX(player.getVelX() + player.ACCELERATION);
  } 
  else 
  {
    if (abs(player.getVelX()) <= player.DECCELERATION)
    {
      player.setVelX(0);
    } 
    else
    {
      player.setVelX(player.getVelX() - player.DECCELERATION * sign(player.getVelX()));
    }
  }
  
  
  player.update(map); 

  // draw player
  fill(255, 0, 0);
  rect(player.getX(), player.getY(), CELL_SIZE, CELL_SIZE);
}


void keyPressed() {
  if (key == 'g' || key == 'G') {
    generateMap_DrunkardsWalk();
  } else if (key == 'i' || key == 'I') {
    iterateAutomata();
  }

  if (key == CODED) {
    if (keyCode == UP) {
      key_Up = true;
    }
    if (keyCode == DOWN) {
      key_Down = true;
    }
    if (keyCode == LEFT) {
      key_Left = true;
    }
    if (keyCode == RIGHT) {
      key_Right = true;
    }
  }
}

void keyReleased()
{
  if (key == CODED) {
    if (keyCode == UP) {
      key_Up = false;
    }
    if (keyCode == DOWN) {
      key_Down = false;
    }
    if (keyCode == LEFT) {
      key_Left = false;
    }
    if (keyCode == RIGHT) {
      key_Right = false;
    }
  }
}

// takes a number as input and returns -1 if negative, 0 if 0, and 1 if positive 
int sign(float num)
{
  if (num > 0)
  {
    return 1;
  } 
  else if (num < 0)
  {
    return -1;
  }
  else 
  {
   return 0; 
  }
}

void createShoreline() {
  for (int x = 0; x <= MAP_WIDTH - 1; x++) {
    for (int y = 0; y <= MAP_HEIGHT - 1; y++) {
      for (int xScan = -1; xScan <= 1; xScan++) {
        for (int yScan = -1; yScan <= 1; yScan++) {
          if (x + xScan > 0 && x + xScan < MAP_WIDTH && y + yScan > 0 && y + yScan < MAP_HEIGHT && map[x + xScan][y + yScan] == CELL_OCEAN && map[x][y] == CELL_LAND)
            map[x][y] = CELL_SHORE;
        }
      }
    }
  }
}

