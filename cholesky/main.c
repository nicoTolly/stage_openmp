

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
#include <time.h>
#include "hilbert-mat.h"
#include "mytimer.h"

//define the size of hilbert matrix
#define NHIL 2000

// all implementations can be found in separated files
double * cholesky(double * A, int n);


void show_matrix(double *A, int n) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++)
			printf("%2.5f ", A[i * n + j]);
		printf("\n");
	}
}

int main() {
	int n = 3;
	double m1[] = 
		{25, 15, -5,
		15, 18,  0,
		-5,  0, 11};
	double *c1 = cholesky(m1, n);
	show_matrix(c1, n);
	printf("\n");
	free(c1);

	n = 4;
	double m2[] = 
		{18, 22,  54,  42,
		22, 70,  86,  62,
		54, 86, 174, 134,
		42, 62, 134, 106};
		double *c2 = cholesky(m2, n);
		show_matrix(c2, n);
		free(c2);
	
#ifdef CLOCK
	struct timespec start, end;
#endif

	printf("\n\n");
	double *m3;
	n=NHIL;
	printf("n=%d\n", n);
	m3=malloc(n*n*sizeof(double));
	if (m3 == NULL) perror("malloc error");
	generate_mat(m3, n);
	printf("generated hilbert matrix\n");
	//home-made timer defined in mytimer.c
	gettime((void *) &start);
	//cholesky function defined in three distinct
	// files : basic-cholesky.c, cholesky-for.c
	// and cholesky-dep.c. Corresponding binaries
	// are built across Makefile
	double *c3 = cholesky(m3, n);
	gettime((void *) &end);
	printtime((void *)&start, (void *)&end);
	free(m3);
	free(c3);
	return 0;
}
