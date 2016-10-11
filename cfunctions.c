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

void equalVars(int * newVar, int * var1, int* var2) {

    for (int i = 1; i <= newVar[0]; i++) {
        if (i >= var1[0]+1) {
            newVar[i] = (var2[i] == 0);
        } else if (i >= var2[0] + 1) {
            newVar[i] = (var1[i] == 0);
        } else {
            newVar[i] = var1[i] == var2[i];
        }
    }
}

void notEqualsVars(int * newVar, int * var1, int* var2) {

    for (int i = 1; i <= newVar[0]; i++) {
        if (i >= var1[0]+1) {
            newVar[i] = (var2[i] != 0);
        } else if (i >= var2[0] + 1) {
            newVar[i] = (var1[i] != 0);
        } else {
            newVar[i] = var1[i] != var2[i];
        }
    }
}

void lessVars(int * newVar, int * var1, int* var2) {

    for (int i = 1; i <= newVar[0]; i++) {
        if (i >= var1[0]+1) {
            newVar[i] = (var2[i] < 0);
        } else if (i >= var2[0] + 1) {
            newVar[i] = (var1[i] < 0);
        } else {
            newVar[i] = var1[i] < var2[i];
        }
    }
}

void greatVars(int * newVar, int * var1, int* var2) {

    for (int i = 1; i <= newVar[0]; i++) {
        if (i >= var1[0]+1) {
            newVar[i] = (var2[i] > 0);
        } else if (i >= var2[0] + 1) {
            newVar[i] = (var1[i] > 0);
        } else {
            newVar[i] = var1[i] > var2[i];
        }
    }
}



void makeRange(int *x, int a, int b) {
	int size = (b +1)- a > 0 ? (b+1) - a : 0;

	for(int i = 1; i <= size; i++) {
		x[i] = a+i-1;
	}
}

void setVectorToInt(int * newVar, int value) {
    for (int i = 1; i <= newVar[0]; i++) {
        newVar[i] = value;
    }
}

int getVectorAtInt(int * vector, int index) {
    if (vector[0] <= index) 
        return 0;
    return vector[index+1];
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
