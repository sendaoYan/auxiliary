// 2044977/bug/55227175
// RUN: %timeout_cmd %timeout_compile %c_compiler -O3 -fno-signed-char %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS -fno-signed-char %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^3$}}
#include <stdio.h>
int a, c, l;
char b, h;
int d[4];
short e, j;
static int *f = &d[3];
static char *g = &b;
static long i[28];
void s(char p1) { a = p1; }
static int t(int);
int u(void) {
  t(65535);
  return 0;
}
int t(int p1) {
  int m = 1;
  char **n = &g;
  int k = &h == &n;
  *f = 0;
  for (; m <= 7; m++) {
    int o = 1087046;
    short *p = &j;
    int *q = &c;
    *q |= *p = *g |= 7 ^ p1;
    for (e = 0; e <= 1; e++) {
      if (i[m])
        break;
      p1 ^= o &= d[e + 2];
    }
  }
  long *r[10];
  r[l] = &i[9];
  return p1;
}
int main(int p1, char *v[]) {
  u();
  s(j >> 6);
  printf("%X\n", a);
}

