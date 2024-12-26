// 2044977/bug/55038145
// RUN: %timeout_cmd %timeout_compile %c_compiler -O2 %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^0$}}
#include <stdio.h>
#define a(b) safe_##b
short c, i, n;
int l[6];
int e, f, g, b, h;
static int *m = &g;
unsigned short j;
short a(add_func_uint16_t_u_u)(short o) { return c + o; }
char k() {
  int *a = &f;
  j = safe_add_func_uint16_t_u_u(-6L);
  *a = j;
  n = 0 <= 2 == *a;
  *m = n != *a;
  i = !0 > *a;
  return 0;
}
int ah() {
  int **d[3];
  for (;;)
    d[b] = &m;
}
int main() {
  k();
  for (h = 0; h < 4; h++)
    e = l[e];
  printf("%d\n", i);
}
