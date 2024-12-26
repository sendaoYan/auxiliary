// 2044977/bug/55307146
// RUN: %timeout_cmd %timeout_compile %c_compiler -O3 -fuse-ld=lld -flto=thin %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^7$}}

#include <stdio.h>
int a, b, c, d, e;
int *f = &a;
static int g(unsigned short);
int fn2(void) {
  g(84);
  return b;
}
int g(unsigned short i) {
  for (; i != 4; i = i + (long)3) {
    e = i >= 32 ? 3 : 3 >> i;
    if (e)
      ;
    else {
      *f = 7;
      break;
    }
  }
  d = i;
  return c;
}
int main(int i, char *j[]) {
  fn2();
  printf("%d\n", a);
}

