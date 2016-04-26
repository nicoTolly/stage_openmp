

#define _GNU_SOURCE


#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>
#include <sched.h>
#include <unistd.h>
#include <sys/wait.h>
#include <pthread.h>


#define N 500

#define M 500

#define OMP_PROC_BIND true
void myHandler(int sig)
{
	if (sig == SIGUSR1)
		printf("signal received, continuing\n");
}

void * routine( void * t)
{

	float * t1 = (float *) t;
	clock_t start=clock(), diff;
	for(int i=0;i< 100000000;i++)
	{
		t1[i%N]+= 3.0;
		diff= clock() - start;
		int msec = diff * 1000 / CLOCKS_PER_SEC;
		//printf("Elapsed time = %d\n", msec);
		if (msec > 2000)
		{
			start = clock();
			printf("from child, t1[0]= %f\n", t1[0]);
		}
	}
}

int main( int argc, char** argv) 
{
	float t1[N];
	float t2[M];



	int ret;
	pthread_t th1;

	if ( (ret=pthread_create(&th1, NULL, routine,(void *)t1))==-1)
		perror("could not create thread \n");
	else
	{
		cpu_set_t set, setp, get;
		int r, r1;
		CPU_ZERO(&set);
		CPU_SET(3, &set);
		if ((r=pthread_setaffinity_np(th1, sizeof(cpu_set_t), &set))==-1)
				perror("could not set affinity");
	}
	pthread_join(th1, NULL);
	return 0; 
}
