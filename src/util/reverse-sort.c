/* reverse-sort.c */
/* Written by Quora user Aaron Christianson on 2019-02-22 */
#include <string.h>
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#define MAX 99999

static int cmpstringp(const void *p1, const void *p2)
{
	return strcmp(* (char * const *) p1, * (char * const *) p2);
}

int main(int argc, char *argv[]) {
	char * lines[MAX];
	size_t linecount = 0;
	size_t n = 0;
	char * line = NULL;

   if (2 != argc)
      exit(666);

	FILE *file = fopen(argv[1], "r");
	while (getline(&line, &n, file) != -1) {
		lines[linecount++] = line;
		if (linecount > MAX)
			return 1;
		line = NULL;
		n = 0;
	}
	qsort(&lines[0], linecount-1, sizeof(char *), cmpstringp);
	while (linecount > 0) {
		printf(line = lines[--linecount]);
		free(line);
	}
	return 0;
}