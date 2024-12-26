// 2044977/bug/55409814
// RUN: %timeout_cmd %timeout_compile %c_compiler -O3 %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^8$}}
#include <stdio.h>
struct a {
  int b;
  long c;
} d, e;
static struct a *f = &d, *i = &e;
static struct a **g = &f;
static struct a fn1(struct a *j) {
  for (; d.b == 0; d.b = 8)
    ;
  return *j;
}
short k(void) {
  *i = fn1(*g);
  return 0;
}
int main(int j, char *l[]) {
  k();
  printf("%d\n", e.b);
}

