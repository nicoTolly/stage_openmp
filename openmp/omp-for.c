#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <unistd.h>

int main(int argc, char ** argv){
#pragma omp parallel for ordered
	for (int i =0; i<12; i++){
		for (int j =0; j<12; j++){
			printf("non ordered, i=%d, j=%d\n", i, j);
			sleep(1/((i*j)+1));
#pragma omp ordered
			printf("ordered, i=%d, j=%d\n", i, j);
		}
	}
	return 0;
}
