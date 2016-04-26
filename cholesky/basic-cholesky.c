#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
#include "hilbert-mat.h"
#include <time.h>


double *cholesky(double *A, int n) {
	double *L = (double*)calloc(n * n, sizeof(double));
	if (L == NULL)
		exit(EXIT_FAILURE);
	int i, j, k;
	{

		for (i = 0; i < n; i++){
			for (j = 0; j < (i+1); j++) {
				double s = 0;
				for (k = 0; k < j; k++)
					s += L[i * n + k] * L[j * n + k];
				L[i * n + j] = (i == j) ?
					sqrt(A[i * n + i] - s) :
					(1.0 / L[j * n + j] * (A[i * n + j] - s));
			}
		}
	}
	return L;
}
