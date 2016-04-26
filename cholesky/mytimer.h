#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//use function clock_gettime() to measure
#define CLOCK

void gettime(void * ti);
void printtime(void * start, void * end);
