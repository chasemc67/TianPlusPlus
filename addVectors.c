#include <stdio.h>
#include <stdlib.h>

void printVec(int *x) {
	printf("[");
printf("%d", x[0]);
	for(int i = 1; i < x[0]+1; i++) {
		printf(" %d",x[i]);
	}
	printf(" ]\n");
}

int getMaxSize(int * var, int* var2) {
	if (var[0] > var2[0]) {
		return var[0];
	} else {
		return var2[0];
	}
}

void addVars(int * newVar, int * var1, int* var2) {

	for (int i = 1; i <= newVar[0]; i++) {
		if (i >= var1[0]+1) {
			newVar[i] = var2[i];
		} else if (i >= var2[0] + 1) {
			newVar[i] = var1[i];
		} else {
			newVar[i] = var1[i] + var2[i];
		}
	}
}

void subVars(int * newVar, int * var1, int* var2) {

	for (int i = 1; i <= newVar[0]; i++) {
		if (i >= var1[0]+1) {
			newVar[i] = var2[i];
		} else if (i >= var2[0] + 1) {
			newVar[i] = var1[i];
		} else {
			newVar[i] = var1[i] - var2[i];
		}
	}
}

void mulVars(int * newVar, int * var1, int* var2) {

	for (int i = 1; i <= newVar[0]; i++) {
		if (i >= var1[0]+1) {
			newVar[i] = var2[i];
		} else if (i >= var2[0] + 1) {
			newVar[i] = var1[i];
		} else {
			newVar[i] = var1[i] * var2[i];
		}
	}
}

void divVars(int * newVar, int * var1, int* var2) {

	for (int i = 1; i <= newVar[0]; i++) {
		if (i >= var1[0]+1) {
			newVar[i] = var2[i];
		} else if (i >= var2[0] + 1) {
			newVar[i] = var1[i];
		} else {
			newVar[i] = var1[i] / var2[i];
		}
	}
}


void allocateVec(int **x,int size) {
	*x = (int *) malloc((size+1) * sizeof(int));
    *x[0] = size;
}

int main(int argc, char ** argv) {
	int var1[3];
	int var2[6];

	var1[0] = 2;
	var2[0] = 5;

	var1[1] = 1;
	var2[1] = 1;
	var1[2] = 2;
	var2[2] = 2;
	var2[3] = 3;
	var2[4] = 10;
	var2[5] = 11;


	int max = getMaxSize(var1, var2);


	int *var3; 
	allocateVec(&var3, max);

	addVars(var3, var2, var1);

	printVec(var1);
	printVec(var2);
	printVec(var3);
}