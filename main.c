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
			map[x][y] = 'A';
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
