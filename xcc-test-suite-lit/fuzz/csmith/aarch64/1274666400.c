// 2044977/bug/55197666
// RUN: %timeout_cmd %timeout_compile %c_compiler -O3 -march=armv8.6-a+sve2 %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^2A$}}
#include <stdio.h>
int a, e, i, h, k;
short b;
long f[32];
long c;
static long *d = &c;
static long **g = &d;
int l(void);
int m(void) {
  l();
  long **j[] = {&d, &d};
  return 0;
}
int l(void) {
  for (e = -14; e; ++e)
    for (b = 0; b <= 2; b++)
      for (i = 0; i <= 2; i++) {
        **g = 1;
        for (h = 0; h <= 3; h++)
          f[i * 4 + h]++;
      }
  return 5;
}
int main(int ah, char *ai[]) {
  m();
  a = f[k];
  printf("%X\n", a);
}
