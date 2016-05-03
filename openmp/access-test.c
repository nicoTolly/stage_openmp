#include <stdio.h>
#include <stdlib.h>

#include "mytimer.h"

int main (int argc, char ** argv)
{
	struct timespec start, end;
	int t[100000], x=0;
	for (int i =0; i<100000;i++)
		t[i]=0;
	printf("access to x\n");
	gettime((void *)&start);
	for (int i =0; i<100000;i++)
		x+=2;
	gettime((void *)&end);
	printtime((void *)&start, (void *)&end);
	printf("access to t\n");
	gettime((void *)&start);
	for (int i =0; i<100000;i++)
		t[i]+=2;
	gettime((void *)&end);
	printtime((void *)&start, (void *)&end);
	return 0;
}
