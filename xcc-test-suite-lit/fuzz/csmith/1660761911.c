// 2044977/bug/55198310
// RUN: %timeout_cmd %timeout_compile %c_compiler -O2 %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^-1$}}
#include <stdio.h>
#define a(b) safe_##b
char c;
int d, l, e, f;
short g;
int *j = &d;
long a;
short a(add_func_uint16_t_u_u)(short i, short p2) { return i + p2; }
short a(rshift_func_uint16_t_u_u)(short i, int p2) { return i >> p2; }
static short ad(int i) {
  for (; c != 7; c = safe_add_func_uint16_t_u_u(c, 3)) {
    l = i || (*j = ~e);
    g = safe_rshift_func_uint16_t_u_u(l, 4);
    f = g << i;
    i = f;
  }
  return 1;
}
int al(void) {
  ad(1);
  return a;
}
int main(int i, char *p2[]) {
  al();
  printf("%d\n", d);
}
