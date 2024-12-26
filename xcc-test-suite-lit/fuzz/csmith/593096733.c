// 2044977/bug/56022221
// RUN: %timeout_cmd %timeout_compile %c_compiler -O2  %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^2$}}
#define _BITS_TYPES_H
#define __SLONGWORD_TYPE int
#define __SQUAD_TYPE int
#define __SWORD_TYPE int
#include <bits/typesizes.h>
typedef __OFF_T_TYPE __off_t;
typedef __OFF64_T_TYPE __off64_t;
typedef __SSIZE_T_TYPE __ssize_t;
#include <stdio.h>
int a[3];
int b, c;
int fn1(void) {
  int *d = &a[2];
  for (b = 16; b > -17; b--)
    c |= 3 - (b || d != &b);
  return c;
}
int main(int argc, char *argv[]) {
  fn1();
  printf("%d\n", c);
}

