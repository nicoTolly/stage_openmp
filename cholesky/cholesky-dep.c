
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
#include <time.h>
#include "hilbert-mat.h"



double *cholesky(double *A, int n) {
	double *L = (double*)calloc(n * n, sizeof(double));
	if (L == NULL)
		exit(EXIT_FAILURE);

#pragma omp parallel shared(L,A ) 
#pragma omp single
	{
		for (int i = 0; i < n; i++){
			{
				for (int j = 0; j < (i+1); j++) {
#pragma omp task untied depend(inout: L[n*i:n]) depend(inout:L[n*j:n])
					{
						double s = 0;
						for (int k = 0; k < j; k++)
							s += L[i * n + k] * L[j * n + k];
						L[i * n + j] = (i == j) ?
							sqrt(A[i * n + i] - s) :
							(1.0 / L[j * n + j] * (A[i * n + j] - s));
					}
				}
			}
		}
	}
#pragma omp taskwait
	return L;
}

