// RUN: %timeout_cmd %timeout_compile %c_compiler -O2 %s -o %t && %timeout_cmd %timeout_run %t | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t && %timeout_cmd %timeout_run %t | %FileCheck %s

#include <stdio.h>
// CHECK: llvm is great
const char *msg = "llvm is great";

int main() {
  printf("%s\n", msg);
  return 0;
}
