// 2044977/bug/55353280
// RUN: %timeout_cmd %timeout_compile %c_compiler -O3 -fuse-ld=lld -flto=thin %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^1$}}

#define _BITS_TYPES_H
#define __SLONGWORD_TYPE int
#define __SQUAD_TYPE int
#define __SWORD_TYPE int
#include <bits/typesizes.h>
typedef __OFF_T_TYPE __off_t;
typedef __OFF64_T_TYPE __off64_t;
typedef __SSIZE_T_TYPE __ssize_t;
#include <stdio.h>
#define a(b) safe_##b
int c, d, m, e = 10, f, g, u;
int *volatile i = &c, *p = &m, *j = &c;
char k;
char a(add_func_int8_t_s_s)(char n, char o) { return n + o; }
int a(lshift_func_uint32_t_u_s)(unsigned n, int o) {
  return o >= 2 || n > 5 >> o ? n : n << o;
}
int *l(void);
int q(void) {
  l();
  return 0;
}
int *l(void) {
  *j = 51;
  for (; d <= 8; d = safe_add_func_int8_t_s_s(d, 1)) {
    int r = u = safe_lshift_func_uint32_t_u_s(5, *j);
    k = u;
    g = ((e &= 0 <= 0) || *j) | (k && r);
    *p ^= g;
    *i = 0;
    *j = 0;
  }
  return &f;
}
int main(int n, char *o[]) {
  q();
  printf("%d\n", m);
}
