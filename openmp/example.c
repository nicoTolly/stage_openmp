#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>


#define N 100000
#define M 100000


int main( int argc, char** argv) {
	float t1[N];
	float t2[M];

	for (int i = 0; i<N; i++)
		t1[i]= 3*i + 2.0;

	for (int i=0; i <M; i++)
		t2[i]= i*i + 7.0;

#pragma omp parallel firstprivate(t1, t2)
	{
#pragma omp sections
		{
#pragma omp section
			{
				printf("Thread %d has taken section 1\n", omp_get_thread_num());
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
						printf("from Thread %d, t1[0]= %f\n", omp_get_thread_num(),t1[0]);
					}
				}

			}

#pragma omp section
			{
				printf("Thread %d has taken section 2\n", omp_get_thread_num());
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
		}
	} // end parallel
	return 0; 
}
