#include <ncurses.h>

int main()
{
	intscr();
	printw("Hello World!");
	refresh();
	getch();
	endwin();

	return 0;
}
