// 2044977/bug/55377237
// RUN: %timeout_cmd %timeout_compile %c_compiler -O1 %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^4$}}
#include <stdio.h>
#pragma pack(1)
struct {
  signed : 11;
  signed : 22;
  unsigned : 1;
  signed a : 8;
  signed : 25;
  signed b : 14;
  unsigned : 21;
  signed : 20;
  unsigned : 7;
  volatile signed c : 27;
} d = {0, 4};
int e(void) {
  d.c = d.a = d.b;
  return 3;
}
int main(int argc, char *argv[]) {
  e();
  printf("%d\n", d.c);
}

