#include <stdio.h>

void createRange(int * a, int start, int end) {	
	a[0] = (1+end-start) > 0 ? (1+end - start) : 0;
	for (int i = 1; i <= (1+end-start); i++) {
		a[i] = start+(i-1);
	}
}

int main(int argc, char ** argv) {
	int startRange = 1;
	int endRange = 9;
	int a[2 + endRange-startRange];

	createRange(a, startRange, endRange);
	
	printf("%d\n", a[9]);
}
