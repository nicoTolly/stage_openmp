
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>



int main() {
	int  tid;
	int shared=10;
	int fpriv = 14;

	#pragma omp parallel firstprivate(fpriv) \
	shared(shared) private(tid) 
	{
		tid = omp_get_thread_num();
		printf("hello from thread %d\n", tid);

		shared++;
		fpriv++;
		if (tid == 0)
			printf("Hello World \n");

	}


	return 0;
}
