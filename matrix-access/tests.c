#include <assert.h>
#include <stdio.h>

extern int matrixIndex(int *matrix, int rows, int cols, int rindex, int cindex);

int main(void) {

  // // Test that rindex > rows returns 0
  // int matrix0[1][4] = {{1, 2, 3, 4}};
  // assert(index((int *)matrix0, 1, 4, 5, 2) == 0);

  // // Test that cindex > cols returns 0
  // int matrix1[1][4] = {{1, 2, 3, 4}};
  // assert(index((int *)matrix1, 1, 4, 0, 5) == 0);

  int matrix2[1][4] = {{1, 2, 3, 4}};
  assert(matrixIndex((int *)matrix2, 1, 4, 0, 2) == 3);

  int matrix3[4][1] = {{1}, {2}, {3}, {4}};
  assert(matrixIndex((int *)matrix3, 4, 1, 1, 0) == 2);

  int matrix4[2][3] = {{1, 2, 3}, {4, 5, 6}};
  assert(matrixIndex((int *)matrix4, 2, 3, 1, 2) == 6);

  int matrix5[4][3] = {{1, 2, 3}, {4, 5, 6}, {14, 35, 46}, {44, 52, 65}};
  assert(matrixIndex((int *)matrix5, 4, 3, 3, 2) == 65);

  printf("OK\n");
}
