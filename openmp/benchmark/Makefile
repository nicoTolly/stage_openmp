CC=gcc
CFLAGS=-Wall -fpic -fopenmp -mavx2 

.PHONY: all
.PHONY: clean

all: copy tiledcopy sum suminplace store

copy: ../reg.c
	$(CC) $(CFLAGS) -D COPY -o copy ../reg.c

tiledcopy: ../reg.c
	$(CC) $(CFLAGS) -D TILEDCOPY -o tiledcopy ../reg.c

sum: ../reg.c
	$(CC) $(CFLAGS) -D SUM -o sum ../reg.c

suminplace: ../reg.c
	$(CC) $(CFLAGS) -D SUMINPLACE -o suminplace ../reg.c

store: ../reg.c
	$(CC) $(CFLAGS) -D STORE -o store ../reg.c

clean:
	rm -fr copy tiledcopy sum suminplace store

