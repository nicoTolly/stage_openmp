
#define _GNU_SOURCE


#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>
#include "mytimer.h"


#define N 200
#define K 10000000


int main( int argc, char** argv) {
	float t1[N];
	float t2[N];

	for (int i = 0; i<N; i++)
		t1[i]= 3*i + 2.0;


	struct timespec start, finish;
	gettime((void *) &start);
#pragma omp parallel shared(t1, t2)
#pragma omp single
		{
			
#pragma omp task 
			{

				for(long int i=0;i<K;i++)
				{
					t1[i%N]+= 3.0;
					//printf("Elapsed time = %d\n", msec);
				}

			}

#pragma omp task
			{

				for(long int i=0;i<K;i++)
				{
					t1[i%N]-= 4.0;
				}

			}

			
		
#pragma omp taskwait
	} // end parallel
		//sectime = omp_get_wtime() - startw;
		gettime((void *) &finish);
		printtime((void *) &start,(void *) &finish);
		//printf("Elapsed time global with wtime= %e µs\n", sectime*1000000.0);
	return 0; 
}


