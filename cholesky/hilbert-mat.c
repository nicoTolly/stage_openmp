#include <stdlib.h>
#include <stdio.h>
#include "hilbert-mat.h"

void generate_mat(double * A, int n)
{
	for (int i=0; i<n; i++)
	{
		for (int j=0; j<n; j++)
		{
			A[n*i + j]=1.0 / (i + j + 1);
		}
	}

}
