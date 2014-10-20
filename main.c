#include <ncurses.h>

#define MAP_WIDTH 10
#define MAP_HEIGHT 10

void genMap();
void draw();

char map[MAP_WIDTH][MAP_HEIGHT];

int main()
{	
	initscr();

    genMap();
	draw();
	refresh();
	getch();
	endwin();

	return 0;
}

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

void draw()
{
    for(int x = 0; x <= MAP_WIDTH; x++)
	{
		for(int y = 0; y <= MAP_HEIGHT; y++)
		{
			mvprintw(x, y, "%c", map[x][y]);
		}
	}
}
