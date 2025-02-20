#include <assert.h>
#include <stdio.h>

extern int fib(int n);

int main(void) {
  assert(fib(0) == 0);
  assert(fib(1) == 1);
  assert(fib(2) == 1); // fib(1) + fib(0)
  assert(fib(3) == 2); // fib(2) + fib(1)
  assert(fib(4) == 3); // fib(3) + fib(2)
  assert(fib(10) == 55);
  assert(fib(12) == 144);
  printf("OK\n");
}
