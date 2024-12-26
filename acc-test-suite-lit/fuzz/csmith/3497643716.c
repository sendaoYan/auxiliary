// 2044977/bug/55412801 
// RUN: %timeout_cmd %timeout_compile %c_compiler -O1 %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t | %FileCheck %s
// CHECK: {{^7$}}
#include <stdio.h>
#pragma pack(1)
struct {
  signed a : 16;
  unsigned : 19;
  signed : 22;
  unsigned : 21;
  signed : 31;
  unsigned : 24;
  unsigned b : 28;
} c = {7}, d;
long e(void) {
  d.b = c.a;
  return 0;
}
int main(int argc, char *argv[]) {
  e();
  printf("%d\n", d.b);
}

