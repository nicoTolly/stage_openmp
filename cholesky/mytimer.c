#include "mytimer.h"


void gettime(void * ti)
{
#ifdef CLOCK
	clock_gettime(CLOCK_MONOTONIC, (struct timespec *)ti);
#endif
}

void printtime(void * start, void * end)
{
#ifdef CLOCK
	struct  timespec *sstart, *send;
	sstart = (struct timespec *) start;
	send = (struct timespec *) end;
	double elapsed = (send->tv_sec - sstart->tv_sec)*1000.0+ (send->tv_nsec- sstart->tv_nsec)/1000000.0;
#endif
	printf("Elapsed time : %e ms\n",elapsed);
}
