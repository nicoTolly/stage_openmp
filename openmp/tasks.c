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

int main( int argc, char** argv) {
	float t1[N];
	float t2[M];

	for (int i = 0; i<N; i++)
		t1[i]= 3*i + 2.0;

	for (int i=0; i <M; i++)
		t2[i]= i*i + 7.0;

	int t=0;
	int q=0;
#pragma omp parallel firstprivate(t1, t2) 
#pragma omp single nowait
		{
#pragma omp task depend(in:t)
			{
				printf("t=%d, starting to sleep\n", t);
				sleep(4);
				printf("done\n");
			}
#pragma omp task depend(in:t)
			{
				printf("t=%d in task 2\n",  t);
			}
#pragma omp task depend(out:t)
			{
				printf("Thread %d has taken task 1\n", omp_get_thread_num());
				clock_t start=clock(), diff;

				t++;
				int r = t;
				if(t1[2]*t1[2]<0) printf("%d", r);
				for(int i=0;;i++)
				{
					t1[i%N]+= 3.0;
					diff= clock() - start;
					int msec = diff * 1000 / CLOCKS_PER_SEC;
					//printf("Elapsed time = %d\n", msec);
					if (msec > 2000)
					{
						start = clock();
						printf("from Thread %d, t1[0]= %f\n", omp_get_thread_num(),t1[0]);
					}
				}

			}

#pragma omp task depend(in:t)
			printf("t=%d\n", t);
#pragma omp task
			{
				printf("Thread %d has taken task 2\n", omp_get_thread_num());

				clock_t start=clock(), diff;
				for(int i=0;;i++)
				{
					t2[i%N]-= 4.0;
					diff=  clock() - start;
					int msec = diff * 1000 / CLOCKS_PER_SEC;
					if (msec > 2000)
					{
						start = clock();
						printf("from Thread %d, t2[0]= %f\n", omp_get_thread_num(),t2[0]);
					}
				}

			}
		
	} // end parallel
	return 0; 
}
