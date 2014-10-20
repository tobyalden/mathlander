#include <ncurses.h>

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
	initscr();
    noecho();
    curs_set(0);
    
    genMap();
    
	draw();
	refresh();
    
    bool loop = true;
    char c;
    while(loop)
    {
        c = getch();
        if(c == 'h')
        {
            player.x = player.x - 1;
        }
        else if(c == 'j')
        {
            player.y = player.y + 1;
        }
        else if(c == 'k')
        {
            player.y = player.y - 1;
        }
        else if(c == 'l')
        {
            player.x = player.x + 1;
        }
        else if(c == 'Q')
        {
            loop = false;
        }
        draw();
        refresh();
    }
    
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
    // draw map
    for(int x = 0; x <= MAP_WIDTH; x++)
	{
		for(int y = 0; y <= MAP_HEIGHT; y++)
		{
			mvprintw(y, x, "%c", map[x][y]);
		}
	}
    
    // draw player
    mvprintw(player.y, player.x, "@");
    
}
