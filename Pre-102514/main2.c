#include <stdlib.h>
#include <time.h>
#include <ncurses.h>

#define MAP_WIDTH 1000
#define MAP_HEIGHT 1000

#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 30

#define ADJ_MAX 4
#define NUMBER_OF_ITERATIONS 5

void scrollMap();
void genMap();
void encloseMap();
void randomFillMap();
void iterateAutomata();
int countSurroundingSolids();
void scrollCamera();
void draw();

struct point {
    int x;
    int y;
};

struct point player = {SCREEN_WIDTH/2, SCREEN_HEIGHT/2};
struct point camera = {0, 0};
char map[MAP_WIDTH][MAP_HEIGHT];

int main()
{
    // Initialize NCurses
	initscr();
    // Prevent NCurses from displaying keyboard input
    noecho();
    // Hide the terminal cursor
    curs_set(0);
    // Allow the use of arrow keys on Mac OS X
    keypad(stdscr, TRUE);
    // Initializes random number generator
    time_t t;
    srand((unsigned) time(&t));
    
    // Generate the map
    genMap();
    
    // Initial draw/refresh before the game enters the main loop
	draw();
	refresh();
    
    // The main loop of the game (should be moved to its own function)
    bool loop = true;
    int c;
    while(loop)
    {
        // Take keyboard input and assigns its value to c
        c = getch();
        
        // Switch containing all the possible actions pertaining to each key
        switch (c) {
            case KEY_UP:
                player.y = player.y - 1;
                break;
                
            case KEY_DOWN:
                player.y = player.y + 1;
                break;
                
            case KEY_LEFT:
                player.x = player.x - 1;
                break;
                
            case KEY_RIGHT:
                player.x = player.x + 1;
                break;
                
            case 'i':
                iterateAutomata();
                break;
                
            case 'Q':
                loop = false;
                break;
                
            default:
                break;
        }
        
        scrollCamera();

        // Draw the updated world
        draw();
    }
    
    // Close NCurses
	endwin();
    // Close Program
	return 0;
}

// Scrolls the map
void scrollCamera()
{
    camera.x = player.x;
    camera.y = player.y;
}


// Generates the map
void genMap()
{
   	randomFillMap();
    
    for(int i = 0; i < NUMBER_OF_ITERATIONS; i++)
    {
        iterateAutomata();
    }
    
    encloseMap();
}

// Randomly fill the inside of the map with walls
void randomFillMap()
{
    for(int x = 0; x <= MAP_WIDTH; x++)
	{
		for(int y = 0; y <= MAP_HEIGHT; y++)
		{
            if(rand() > RAND_MAX/2)
            {
                map[x][y] = 'X';
            }
            else
            {
                map[x][y] = '.';
            }
            
		}
	}
}

// Enclose the sides of the map with walls
void encloseMap()
{
    for(int x = 0; x <= MAP_WIDTH; x++)
	{
		for(int y = 0; y <= MAP_HEIGHT; y++)
		{
            // Enclose the sides of the map with walls
            if(x == 0 || y == 0 || x == MAP_WIDTH || y  == MAP_HEIGHT)
            {
                map[x][y] = 'X';
            }
		}
	}
}

// Iterates cellular automata
void iterateAutomata()
{
    for(int x = 0; x <= MAP_WIDTH; x++)
	{
		for(int y = 0; y <= MAP_HEIGHT; y++)
		{
            int adjCount = countSurroundingSolids(x, y, 1);
            if (adjCount > ADJ_MAX)
            {
                map[x][y] = 'X';
            }
            else
            {
                map[x][y] = '.';
            }
        }
    }
}

// Counts the number of walls centered around a given point, within a given radius. Includes the point itself.
int countSurroundingSolids(x, y, radius)
{
    int wallCount = 0;
    for (int xScan = x - radius; xScan <= x + radius; xScan++)
    {
        if (xScan > 0 && xScan <= MAP_WIDTH - 1)
        {
            for (int yScan = y - radius; yScan <= y + radius; yScan++)
            {
                if (yScan > 0 && yScan <= MAP_HEIGHT - 1)
                {
                    if (map[xScan][yScan] == 'X')
                    {
                        wallCount++;
                    }
                }
            }
        }
    }
    return wallCount;
}

// Draws the world to the screen
void draw()
{
    // Draw map
    for(int x = 0; x <= SCREEN_WIDTH; x++)
	{
		for(int y = 0; y <= SCREEN_HEIGHT; y++)
		{
			mvprintw(y, x, "%c", map[x + camera.x][y + camera.y]);
		}
	}
    
    // Draw player
    mvprintw(player.y, player.x, "@");
    
    
    // Draw changes to the screen
    refresh();
}
