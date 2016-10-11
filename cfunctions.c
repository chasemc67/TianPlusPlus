#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
void allocateVec(int **x,int size) {
	*x = (int *) malloc((size+1) * sizeof(int));
    *x[0] = size;
}

void printVec(int *x) {
	printf("[");
printf("%d", x[0]);
	for(int i = 1; i < x[0]+1; i++) {
		printf(" %d",x[i]);
	}
	printf(" ]\n");
}

void swapVec(int **x, int **y) {
    int *tmp = *x;
    *x = *y;
    *y = tmp;
}
void makeRange(int *x, int a, int b) {
	int size = (b +1)- a > 0 ? (b+1) - a : 0;

	for(int i = 1; i <= size; i++) {
		x[i] = a+i-1;
	}
}

int main(int argc, char *argv[])
{
    /*int *x;
    allocateVec(&x,3);
    x[1] = 4;
    x[2] = 2;
    x[3] = 1;
    printVec(x);
    int *y;
    allocateVec(&y,3);
    y[1] = 9;
    y[2] = 8;
    y[3] = 7;
    printVec(y);
    swapVec(&x, &y);
    printVec(x);
    printVec(y);
printf("44524353");*/
    int  a = 1;
    int b = 5;
	int *vec;
    int size = b - a + 1;
    allocateVec(&vec,size);
	makeRange(vec,1,5);
	printVec(vec);
}
