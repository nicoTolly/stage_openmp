#include <omp.h>
#include <unistd.h>
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>
#include <immintrin.h>
#include <stdint.h>

//#define DEBUG

#include <sys/time.h>
// Time
#ifdef __MACH__
#  include <mach/clock.h>
#  include <mach/mach.h>
#  include <time.h>
#  include <sys/time.h>

#  define CLOCK_REALTIME 0
#  define CLOCK_MONOTONIC 0
int clock_gettime(int clk_id, struct timespec *ts)
{
	clock_serv_t cclock;
	mach_timespec_t mts;
	host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
	clock_get_time(cclock, &mts);
	mach_port_deallocate(mach_task_self(), cclock);
	ts->tv_sec = mts.tv_sec;
	ts->tv_nsec = mts.tv_nsec;
	return 0;
}
#else
#  include <time.h>
#endif

// Cycles
static inline unsigned long get_cycles()
{
	uint32_t eax = 0, edx;

	__asm__ __volatile__("cpuid;"
			"rdtsc;"
			: "+a" (eax), "=d" (edx)
			:
			: "%rcx", "%rbx", "memory");

	__asm__ __volatile__("xorl %%eax, %%eax;"
			"cpuid;"
			:
			:
			: "%rax", "%rbx", "%rcx", "%rdx", "memory");

	return (((uint64_t)edx << 32) | eax);
}


#define NUM_THREADS 4
#define MAX_RATIO 0L
#define HASWELL 
#ifdef PAPI
#include "papi_by_set.h"
#else
#define pbs_papi_init(a) { printf("not using papi counters\n");}
#define pbs_papi_close() {}
#define pbs_papi_start_counter(a) {}
#define pbs_papi_stop_counter(a) {}
#define pbs_num_counter_sets() 1
#endif

#define cmin 1024
#define cmax 1024*1024*256
#define N 1024*1024*128
#define thr (0.5)
// #define cmax 1024*4
// #define n 1024*4
double A[N],B[N],C[N];

#ifdef HASWELL
#define VLOAD _mm256_load_pd
#define VSTORE _mm256_store_pd
#define VSETZERO _mm256_setzero_pd
#define VSETHALPH _mm256_set_pd(0.5,0.5,0.5,0.5)
#define VADD _mm256_add_pd
#define VFMADD _mm256_fmadd_pd
#define VTYPE __m256d
#define BYTES_PERWORD 8
#define BYTES_PERDOUBLE BYTES_PERWORD 
#define WORDS_PERVECTOR 4
#define BYTES_PERVECTOR WORDS_PERVECTOR*BYTES_PERWORD
#define VECTORS_PERLINE 2
#define BYTES_PERLINE VECTORS_PERLINE*BYTES_PERVECTOR
#define WORDS_PERLINE WORDS_PERVECTOR*VECTORS_PERLINE
#else
other architectures not handled
#endif
#define DUMP_VALUES() {printf("BYTES_PERWORD:%d, BYTES_PERDOUBLE:%d, WORDS_PERVECTOR:%d, BYTES_PERVECTOR:%d, VECTORS_PERLINE:%d, BYTES_PERLINE:%d", BYTES_PERWORD, BYTES_PERDOUBLE, WORDS_PERVECTOR, BYTES_PERVECTOR, VECTORS_PERLINE, BYTES_PERLINE);}

unsigned long nbvloads; // nber of vector loads
unsigned long nbvstores; // nber of vector stores
unsigned long nblloads; // nber of line "loads"
unsigned long nblstores; // nber of line "stores"
unsigned long nblloads4stores; //nber of line that need to be brought up because of a "store"
unsigned long nbvinsts; // nber of vector instructions (double)
unsigned long cb; // size of the chunk (in bytes)
VTYPE trash;

void init(double *a, int size)
{
	int i;
	for (i=0;i<size;i++) {
		a[i]=0.5;
	}
}

#ifdef COPY
void copy(double *restrict a, double *restrict b, int size)
{
	int i;
	VTYPE tmp;

	size /= 2;
	assert(size%WORDS_PERVECTOR==0);
	for (i=0;i<size; i+=WORDS_PERVECTOR) {
		tmp = VLOAD(&a[i]);
		nbvloads++;
		VSTORE(&b[i],tmp);
		nbvstores++;
	}
	cb = 2*sizeof(double)*size;
	nblloads = nbvloads/VECTORS_PERLINE;
	nblstores = nbvstores/VECTORS_PERLINE;
	nblloads4stores = nblstores;
}
#endif

#ifdef TILEDCOPY
void copy(double *restrict a, double *restrict b, int size)
{
	int i,ii;
	VTYPE tmp;
	int n=512;
	int B=32;

	size /= 2;
	assert(size%WORDS_PERVECTOR==0);
	for (ii=0;ii<size;ii+=n*WORDS_PERVECTOR) 
		for (i=ii;i<ii+B*WORDS_PERVECTOR;i+=WORDS_PERVECTOR) {
			tmp = VLOAD(&a[i]);
			nbvloads++;
			VSTORE(&b[i],tmp);
			nbvstores++;
		}
	cb = 2*sizeof(double)*size;
	nblloads = nbvloads/VECTORS_PERLINE;
	nblstores = nbvstores/VECTORS_PERLINE;
	nblloads4stores = nblstores;
}
#endif

#ifdef SUM
void sum(double *restrict a, double *restrict b, double *restrict c, int size)
{
	int i;
	VTYPE tmp1, tmp2, tmp;

	size /= 2;
	size = size / (WORDS_PERVECTOR*2);
	size = size * (WORDS_PERVECTOR*2);
	for (i=0;i<size; i+=WORDS_PERVECTOR) {
		tmp1 = VLOAD(&a[i]);
		tmp2 = VLOAD(&b[i]);
		nbvloads+=2;
		tmp = VADD(tmp1, tmp2);
		nbvinsts++;
		VSTORE(&c[i],tmp);
		nbvstores++; 
	}
	cb = 3*sizeof(double)*size;
	nblloads = nbvloads/VECTORS_PERLINE;
	nblstores = nbvstores/VECTORS_PERLINE;
	nblloads4stores = nblstores;
}
#endif

#ifdef SUMINPLACE
void suminplace(double *a, int size)
{
	int i;
	VTYPE tmp1, tmp2, tmp;

	size = size / (WORDS_PERVECTOR*4);
	size = size * (WORDS_PERVECTOR*4);
	for (i=0;i<size; i+=WORDS_PERVECTOR*2) {
		tmp1 = VLOAD(&a[i]);
		tmp2 = VLOAD(&a[i+WORDS_PERVECTOR]);
		nbvloads+=2;
		tmp = VADD(tmp1, tmp2);
		nbvinsts++;
		VSTORE(&a[i],tmp);
		nbvstores++;
	}
	cb = sizeof(double)*size;
	nblloads = nbvloads/VECTORS_PERLINE;
	nblstores = nbvstores;
}
#endif

#ifdef LOAD
void load(double *restrict a, int size)
{
	unsigned long i;
	VTYPE reduc1, reduc2, reduc3, reduc4, reduc5, reduc6, reduc7, reduc8, reduc9, reducA, reducB, reducC, reducD, reducE, reducF, reducG;
	VTYPE coef = VSETHALPH;

	reduc1 = VSETZERO();
	reduc2 = VSETZERO();
	reduc3 = VSETZERO();
	reduc4 = VSETZERO();
	reduc5 = VSETZERO();
	reduc6 = VSETZERO();
	reduc7 = VSETZERO();
	reduc8 = VSETZERO();
	reduc9 = VSETZERO();
	reducA = VSETZERO();
	reducB = VSETZERO();
	reducC = VSETZERO();
	reducD = VSETZERO();
	reducE = VSETZERO();
	reducF = VSETZERO();
	reducG = VSETZERO();
	trash = VSETZERO();
	for (i=0;i<size; i+=WORDS_PERVECTOR*12) {
		reduc1 = VFMADD(coef, VLOAD(&a[i]), reduc1);
		reduc2 = VADD(VLOAD(&a[i+WORDS_PERVECTOR]), reduc2);
		reduc3 = VFMADD(coef, VLOAD(&a[i+2*WORDS_PERVECTOR]), reduc3);
		reduc4 = VADD(VLOAD(&a[i+3*WORDS_PERVECTOR]), reduc4);
		reduc5 = VFMADD(coef, VLOAD(&a[i+4*WORDS_PERVECTOR]), reduc5);
		reduc6 = VADD(VLOAD(&a[i+5*WORDS_PERVECTOR]), reduc6);
		reduc7 = VFMADD(coef, VLOAD(&a[i+6*WORDS_PERVECTOR]), reduc7);
		reduc8 = VADD(VLOAD(&a[i+7*WORDS_PERVECTOR]), reduc8);
		reduc9 = VFMADD(coef, VLOAD(&a[i+8*WORDS_PERVECTOR]), reduc9);
		reducA = VADD(VLOAD(&a[i+9*WORDS_PERVECTOR]), reducA);
		reducB = VFMADD(coef, VLOAD(&a[i+10*WORDS_PERVECTOR]), reducB);
		reducC = VADD(VLOAD(&a[i+11*WORDS_PERVECTOR]), reducC);
		/*reducD = VFMADD(coef, VLOAD(&a[i+12*WORDS_PERVECTOR]), reducD);
		  reducE = VADD(VLOAD(&a[i+13*WORDS_PERVECTOR]), reducE);
		  reducF = VFMADD(coef, VLOAD(&a[i+14*WORDS_PERVECTOR]), reducF);
		  reducG = VFMADD(coef, VLOAD(&a[i+15*WORDS_PERVECTOR]), reducG); */
		nbvloads+=12;
		nbvinsts+=12;
	}
	trash=VADD(VADD(trash, VADD(reduc1, reduc2)), VADD(reduc3, reduc4));
	trash=VADD(VADD(trash, VADD(reduc5, reduc6)), VADD(reduc7, reduc8));
	trash=VADD(VADD(trash, VADD(reduc9, reducA)), VADD(reducB, reducC));
	trash=VADD(VADD(trash, VADD(reducD, reducE)), VADD(reducF, reducG));
	cb = sizeof(double)*size;
	nblloads = nbvloads/VECTORS_PERLINE;
}
#endif

#ifdef STORE
void store(double *a, int size)
{
	unsigned long i;
	VTYPE zero = VSETZERO();;

	assert(size%(WORDS_PERVECTOR*2)==0);
	for (i=0;i<size; i+=WORDS_PERVECTOR) {
		VSTORE(&a[i], zero);
		nbvstores+=1;
	}
	/*for (i=0;i<size;i+=WORDS_PERLINE) {
	  a[i]=i;
	  nblstores++;
	  }*/
	cb = sizeof(double)*size;
	nblstores = nbvstores/VECTORS_PERLINE;
	nblloads4stores = nblstores;
}
#endif


int siz(int n)
{ int frac;
	frac = n/1024;
	if (frac == 0) return(n);
	n = n/1024;
	frac = n/1024;
	if (frac == 0) return(n);
	n = n/1024;
	frac = n/1024;
	if (frac == 0) return(n);
	n = n/1024;
	frac = n/1024;
	if (frac == 0) return(n);
	printf("Error: n is too large!\n");
}

char units(int n)
{ int frac;
	frac = n/1024;
	if (frac == 0) return(' ');
	n = n/1024;
	frac = n/1024;
	if (frac == 0) return('K');
	n = n/1024;
	frac = n/1024;
	if (frac == 0) return('M');
	n = n/1024;
	frac = n/1024;
	if (frac == 0) return('G');
	printf("Error: n is too large!\n");
}

void process(){
	double rtclock();

	double clkbegin, clkend, s;
	unsigned long ticbegin, ticend;
	long t;

	int i, j, c, niter, nthreads;

	/*  for(i=0;i<N;i++)
	    { 
	    A[i] = (i+2.0)/(2.0*N);
	    }*/
#ifdef COPY       
#elif defined TILEDCOPY
#elif defined SUM
	init(B,N);
	init(C,N);
#elif defined SUMINPLACE
	init(A,N);
#elif defined LOAD
	init(A,N);
	init(B,N);
#elif defined STORE
#else
	hum need to define something
#endif

		omp_set_num_threads(NUM_THREADS);
	for(c=cmin; c<cmax; c*=2){
#pragma omp parallel private(i)
		{
			int trial, myid, nthrds;
			long chunksz, startidx;
			myid = omp_get_thread_num();
			nthrds = omp_get_num_threads();
			chunksz = c/nthrds; 
			startidx = c*myid;
			if (myid == 0) {
				niter = 1; s= 0.0;
				// trying to find the right
				// value of niter so a complete loop
				// will take more than thr seconds
				// ( thr = 0,5 )
				while (s<thr) { 
					// increase niter exponentially
					niter *=2;
					clkbegin = rtclock();//start of counter
					for (i=0; i<niter; i++)
					{
#ifdef COPY       
						copy(B,A,c);
#elif defined TILEDCOPY
						copy(B,A,c);
#elif defined SUM
						sum(A,B,C, c);
#elif defined SUMINPLACE
						suminplace(A, c);
#elif defined LOAD
						load(A, c);
#elif defined STORE
						store(A, c);
#else
						hum need to define something
#endif
					}
					clkend = rtclock();//end of counter
					s = clkend-clkbegin;
				}
			}

			// 5 trials ( what for ? )
			for(trial=0;trial<5;trial++)
			{
#pragma omp barrier //every thread must have finished so everyone starts at the same
				// time
				
				clkbegin = rtclock();
				ticbegin = get_cycles();
				nbvloads = 0;
				nbvstores = 0;
				nbvinsts = 0;
				nblloads = 0; // number of line loads
				nblstores = 0; // number of line stores
				nblloads4stores = 0;
				//working
				for (i=0; i<niter; i++)
				{
#ifdef COPY       
					copy(&(B[startidx]), &(A[startidx]), chunksz);
#elif defined TILEDCOPY
					copy(&(B[startidx]), &(A[startidx]), chunksz);
#elif defined SUM
					sum(&(B[startidx]), &(C[startidx]), &(A[startidx]), chunksz);
#elif defined SUMINPLACE
					suminplace(&(A[startidx]), chunksz);
#elif defined LOAD
					load(&(A[startidx]), chunksz);
#elif defined STORE
					store(&(A[startidx]), chunksz);
#else
					hum need to define something
#endif
				}
				ticend = get_cycles();
				clkend = rtclock();
				t = ticend-ticbegin;
				s = clkend-clkbegin;
				// To foil compiler optimizer - "dead code" elimination
				if (A[N/2]*A[N/2] < -100.0) printf("%f\n",A[N/2]);
				/*   printf("Thread[%d] \tTrial %d: Size = %d%c \tTime = %.3f sec \tTics = %.3f Gcycles \tGFreq=%.3g \t%.2f GVloads/s \t%.2f GVstores/s \t%.2f GVinsts/s\n",
				     myid, trial, siz(cb*nthrds), units(cb*nthrds), s, ((double) t)/1e9, ((double) t)/1e9/s, nbvloads*1e-9/s, nbvstores*1e-9/s, nbvinsts*1e-9/s); */
				printf("Thread[%d] \tTrial %d: Size = %d%c \tGFreq=%.3g  \t%.2f GVinsts/s \t%.2f GVloads/s \t%.2f GVstores/s \t%.2f (S)GBytes/s \t%.2f (L+sL)GBytes/s \t%.2f (L)GBytes/s \t%.2f (L+sL+S)GBytes/s\t%.2f (L+S)GBytes/s\n",
						myid, trial, siz(cb*nthrds), units(cb*nthrds), ((double) t)/1e9/s, nbvinsts*1e-9/s, nbvloads*1e-9/s, nbvstores*1e-9/s, (nblstores)*BYTES_PERLINE*1e-9/s, (nblloads+nblloads4stores)*BYTES_PERLINE*1e-9/s, (nblloads)*BYTES_PERLINE*1e-9/s, (nblloads+nblstores+nblloads4stores)*BYTES_PERLINE*1e-9/s, (nblloads+nblstores)*BYTES_PERLINE*1e-9/s);
			}
		}
	}
}

double rtclock()
{
	struct timezone Tzp;
	struct timeval Tp;
	int stat;
	stat = gettimeofday (&Tp, &Tzp);
	if (stat != 0) printf("Error return from gettimeofday: %d",stat);
	return(Tp.tv_sec + Tp.tv_usec*1.0e-6);
}

void papi_profile()
{
	int counterSetId, numCounterSets = pbs_num_counter_sets();

	for(int i=0;i<N;i++)
	{ 
		A[i] = (i+2.0)/(2.0*N);

	}
	for (long ratio = 0; ratio <= MAX_RATIO; ratio++) {
		int iter; //niter = (1L << 23) / (1L << ratio);

		for (counterSetId = 0; counterSetId < numCounterSets; counterSetId++) {
			pbs_papi_start_counter(counterSetId);

			for (iter= 0; iter < 1; iter++) {
				process();
			}

			pbs_papi_stop_counter(counterSetId);

		}
	}
}



int main()
{
	char *name="benchmark";
	pbs_papi_init(name);
	papi_profile();
	pbs_papi_close();
}
