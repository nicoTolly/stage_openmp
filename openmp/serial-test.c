

#define _GNU_SOURCE


#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>

#include "mytimer.h"

#define N 500
#define K 10000000


int main( int argc, char** argv) {
	float t1[N];
	float t2[N];
	float t3[N];
	float t4[N];
	float t5[N];
	float t6[N];
	float t7[N];
	float t8[N];

	for (int i = 0; i<N; i++)
		t1[i]= 3*i + 2.0;

	for (int i=0; i <N; i++)
		t2[i]= i*i + 7.0;

	for (int i = 0; i<N; i++)
		t4[i]= 3*i + 2.0;
	for (int i = 0; i<N; i++)
		t3[i]= 3*i + 2.0;
	for (int i = 0; i<N; i++)
		t5[i]= 3*i + 2.0;
	for (int i = 0; i<N; i++)
		t6[i]= -3*i + 2.0;
	for (int i = 0; i<N; i++)
		t7[i]= 3*i - 2.0;
	for (int i = 0; i<N; i++)
		t8[i]= 3.5*i + 2.0;
	int t=0;
	int q=0;
	struct timespec start, finish;
	gettime((void *) &start);
	double sectime;
	double startw;
	startw= omp_get_wtime();
		{
			int tid = omp_get_thread_num();
			
			{

				int r = t;
				for(int i=0;i<K;i++)
				{
					t1[i%N]+= 3.0;
					//printf("Elapsed time = %d\n", msec);
				}

			}

			{

				for(int i=0;i<K;i++)
				{
					t2[i%N]-= 4.0;
				}

			}
			{

				for(int i=0;i<K;i++)
				{
					t3[i%N]-= 4.0;
				}

			}
			{

				for(int i=0;i<K;i++)
				{
					t4[i%N]-= 4.0;
				}

			}

			{

				for(int i=0;i<K;i++)
				{
					t5[i%N]-= 4.0;
				}

			}
			{

				for(int i=0;i<K;i++)
				{
					t6[i%N]-= 4.0;
				}

			}
			{

				for(int i=0;i<K;i++)
				{
					t7[i%N]-= 4.0;
				}

			}
			{

				for(int i=0;i<K;i++)
				{
					t8[i%N]-= 4.0;
				}

			}
		
	} // end parallel
		sectime = omp_get_wtime() - startw;
		gettime((void *) &finish);
		printtime((void *) &start,(void *) &finish);
		printf("Elapsed time global with wtime= %e µs\n", sectime*1000000.0);
	return 0; 
}
