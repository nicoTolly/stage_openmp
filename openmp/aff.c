
#define _GNU_SOURCE


#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>
#include <sched.h>
#include <unistd.h>
#include <sys/wait.h>


#define N 500

#define M 500

#define OMP_PROC_BIND true
void myHandler(int sig){
	if (sig == SIGUSR1)
		printf("signal received, continuing\n");
}


int main( int argc, char** argv) {
	float t1[N];
	float t2[M];

	for (int i = 0; i<N; i++)
		t1[i]= 3*i + 2.0;

	for (int i=0; i <M; i++)
		t2[i]= i*i + 7.0;


	int pid;
	if ((pid= fork())==-1)
		perror("could not fork \n");
	else if (pid == 0)//child process
		{	
				cpu_set_t set, setp, get;
				int r, r1;
				CPU_ZERO(&set);
				CPU_ZERO(&setp);
				CPU_SET(0, &set);
				CPU_SET(3, &setp);
				//CPU_SET(2, &setp);
				if ((r=sched_setaffinity(getpid(), sizeof(cpu_set_t), &set))==-1)
						perror("could not set affinity");
				if ((r=sched_setaffinity(getppid(), sizeof(cpu_set_t), &setp))==-1)
						perror("could not set affinity");
				kill(getppid(), SIGUSR1);
				if ((r1=sched_getaffinity(getpid(), sizeof(cpu_set_t), &get))==-1)
						perror("could not get affinity");
				int ncpu=0;
				ncpu = CPU_COUNT(&get);
				printf("from child, number of cpu=%d,\n",  ncpu);
				clock_t start=clock(), diff;

				for(int i=0;;i++)
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
	else //parent process
	{
			
				signal(SIGUSR1,myHandler);
				clock_t start=clock(), diff;
				cpu_set_t set, get;
				int r, r2;
				CPU_ZERO(&set);
				//CPU_SET(0, &set);
				/*CPU_SET(2, &set);
				if (r=sched_setaffinity(getpid(), sizeof(cpu_set_t), &set)==-1)
						perror("could not get affinity");*/
				pause();
				if ((r2=sched_getaffinity(getpid(), sizeof(cpu_set_t), &get))==-1)
						perror("could not get affinity");

				int ncpu=0;
				ncpu = CPU_COUNT(&get);
				printf("from parent, number of cpu=%d,\n",  ncpu);
				for(int i=0;;i++)
				{
					t2[i%N]-= 4.0;
					diff=  clock() - start;
					int msec = diff * 1000 / CLOCKS_PER_SEC;
					if (msec > 2000)
					{
						start = clock();
						printf("from parent, t2[0]= %f\n", t2[0]);
					}
				}

			}
		
	return 0; 
}
