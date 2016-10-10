#include <stdio.h>

void createRange(int * a, int start, int end) {	
	a[0] = end-start > 0 ? end - start : 0;
	for (int i = 1; i <= (end-start); i++) {
		a[i] = start+(i-1);
	}
}

int main(int argc, char ** argv) {
	int startRange = 3;
	int endRange = 7;
	int a[1 + endRange-startRange];

	createRange(a, startRange, endRange);
	
	a[3] = startRange;
	printf("%d\n", a[2]);
}
