
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>



int main() {
	int  tid;

	#pragma omp parallel private(tid)
	{
		tid = omp_get_thread_num();
		printf("hello from thread %d\n", tid);

		if (tid == 0)
			printf("Hello World \n");

	}


	return 0;
}
