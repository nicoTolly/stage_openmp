
#define _GNU_SOURCE


#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>


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

	for (int i = 0; i<N; i++){
		t1[i]= 3*i + 2.0;

		t2[i]= i*i + 7.0;

		t4[i]= 3*i + 2.0;
		t3[i]= 3*i + 2.0;
		t5[i]= 3*i + 2.0;
		t6[i]= -3*i + 2.0;
		t7[i]= 3*i - 2.0;
		t8[i]= 3.5*i + 2.0;
	}
	struct timespec start, finish;
	clock_gettime(CLOCK_REALTIME, &start);
	double sectime;
	double startw;
	startw= omp_get_wtime();
#pragma omp parallel firstprivate(t1, t2, t3, t4) 
#pragma omp single nowait
		{
			int tid = omp_get_thread_num();
			
#pragma omp task 
			{

				for(int i=0;i<K;i++)
				{
					t1[i%N]+= 3.0;
					//printf("Elapsed time = %d\n", msec);
				}

			}

#pragma omp task
			{

				for(int i=0;i<K;i++)
				{
					t2[i%N]-= 4.0;
				}

			}
#pragma omp task
			{

				for(int i=0;i<K;i++)
				{
					t3[i%N]-= 4.0;
				}

			}
#pragma omp task
			{

				for(int i=0;i<K;i++)
				{
					t4[i%N]-= 4.0;
				}

			}

#pragma omp task
			{

				for(int i=0;i<K;i++)
				{
					t5[i%N]-= 4.0;
				}

			}
#pragma omp task
			{

				for(int i=0;i<K;i++)
				{
					t6[i%N]-= 4.0;
				}

			}
#pragma omp task
			{

				for(int i=0;i<K;i++)
				{
					t7[i%N]-= 4.0;
				}

			}
#pragma omp task
			{

				for(int i=0;i<K;i++)
				{
					t8[i%N]-= 4.0;
				}

			}
		
#pragma omp taskwait
	} // end parallel
		sectime = omp_get_wtime() - startw;
		clock_gettime(CLOCK_REALTIME, &finish);
		double elapsed = (finish.tv_sec - start.tv_sec)*1000.0+(finish.tv_nsec - start.tv_nsec)/1000000.0 ;
		printf("Elapsed time global= %f\n", elapsed);
		printf("Elapsed time global with wtime= %e µs\n", sectime*1000000.0);
	return 0; 
}
