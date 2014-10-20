#include <ncurses.h>

<<<<<<< Updated upstream
=======
// penis dong vagina

>>>>>>> Stashed changes
#define MAP_WIDTH 10
#define MAP_HEIGHT 10

void genMap();
void draw();

struct point {
    int x;
    int y;
};

struct point player = {5, 5};
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
                
            case 'Q':
                loop = false;
                
            default:
                break;
        }

        // Draw the updated world
        draw();
    }
    
    // Close NCurses
	endwin();
    // Close Program
	return 0;
}

// Generates the map
void genMap()
{
	for(int x = 0; x <= MAP_WIDTH; x++)
	{
		for(int y = 0; y <= MAP_HEIGHT; y++)
		{
            if(x == 0 || y == 0 || x == MAP_WIDTH || y  == MAP_HEIGHT)
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

// Draws the world to the screen
void draw()
{
    // Draw map
    for(int x = 0; x <= MAP_WIDTH; x++)
	{
		for(int y = 0; y <= MAP_HEIGHT; y++)
		{
			mvprintw(y, x, "%c", map[x][y]);
		}
	}
    
    // Draw player
    mvprintw(player.y, player.x, "@");
    
    
    // Draw changes to the screen
    refresh();
}
