// 2044977/bug/55993228
// RUN: %timeout_cmd 90 %c_compiler -O3 -fuse-ld=lld -flto=thin %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd 90 %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
#define _BITS_TYPES_H
#define __SLONGWORD_TYPE int
#define __SQUAD_TYPE int
#define __SWORD_TYPE int
#include <bits/typesizes.h>
typedef __OFF_T_TYPE __off_t;
typedef __OFF64_T_TYPE __off64_t;
typedef __SSIZE_T_TYPE __ssize_t;
#include <stdio.h>
char a;
struct {
  volatile int ab;
  int ac;
} b;
signed char g = 1;
short e;
static int c, f, h;
signed char *d = &g;
int *k(unsigned);
int l(void) {
  b.ab;
  k(3 <= b.ac);
  return 0;
}
int *k(unsigned m) {
  f ^= m;
  for (c = 0; c < 7; c = c + 5)
    for (e = 0; e != 35; e++)
      *d &m || (*d = 0);
  return 0;
}
int main(int m, char *n[]) {
  int i, j = 0;
  if (m)
    j = 1;
  l();
  for (i = 0; i < 7; i++)
    for (h = 0; h < 4; h++) {
      if (j)
        printf(&a, 5);
      printf("index = %d%d%d\n", i, a, h);
    }
}

