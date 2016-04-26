
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <unistd.h>
#include <time.h>

#include "mytimer.h"

#define N 500000

void work(float * t, float * a, float * b)
{
	for (int i=0; i<N*1000; i++)
	{
		t[i%N]=a[i%N]/b[i%N];
		t[i%N]=t[i%N]/b[i%N];
		t[i%N]=t[i%N]/b[i%N];
	}
}
void work_parallel(float * t, float * a, float * b)
{
#pragma omp parallel for shared(t, a, b)
	for (int i=0; i<N*1000; i++)
	{
		t[i%N]=a[i%N]/b[i%N];
		t[i%N]=t[i%N]/b[i%N];
		t[i%N]=t[i%N]/b[i%N];
	}
}



int main(int argc, char ** argv){
	float* t, * t2;
	
	float a[N], b[N];
	float a1[N], b1[N];
	for(int i=0; i<N;i++)
	{
		a[i]=i*23.5+1;
		b[i]=i*(i+0.4);
		a1[i]=i*23.5+1;
		b1[i]=i*(i+0.4);
	}
	t = malloc(N*sizeof(float));
	t2 = malloc(N*sizeof(float));
	if (t==NULL || t2==NULL) exit(EXIT_FAILURE);

	struct timespec start, finish;

	gettime( (void *) &start);
	work(t, a, b);
	gettime( (void *) &finish);
	printf("Serial : \n");
	printtime((void *) &start, (void *) &finish);
	gettime( (void *) &start);
	work_parallel(t2, a1, b1);
	gettime( (void *) &finish);
	printf("Parallel : \n");
	printtime((void *) &start, (void *) &finish);
	free(t);
	free(t2);
	return 0;
}
