// 2044977/bug/55409910
// RUN: %timeout_cmd %timeout_compile %c_compiler -O1 %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^4$}}
#include <stdio.h>
short a, e;
short b[2];
int c;
long d;
int f(void) {
  short *g = &e;
  d = 4 << 10;
  if (d ^ (g != &b[1]))
    for (; a <= 3; a++)
      ;
  return c;
}
int main(int argc, char *argv[]) {
  f();
  printf("%d\n", a);
}

