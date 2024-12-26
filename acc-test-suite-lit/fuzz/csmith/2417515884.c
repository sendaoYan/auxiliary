// 2044977/bug/55445430
// RUN: %timeout_cmd %timeout_compile %c_compiler -O1 %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^0$}}

#include <stdio.h>
short a[4];
short b;
long c;
int d;
int e(void) {
  short *f = &b, *g = &a[3];
  d = 8 << 9;
  if (d == (g != f))
    c++;
  return 0;
}
char fn2(void) {
  e();
  return 0;
}
int main(int argc, char *argv[]) {
  fn2();
  printf("%d\n", (int)c);
}
