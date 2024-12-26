// RUN: %cc -O2 %s -o %t && %t | %FileCheck %s
// RUN: %cc %OPTFLAGS %s -o %t && %t | %FileCheck %s

#include <stdio.h>
// CHECK: llvm is great
const char *msg = "llvm is great";

int main() {
  printf("%s\n", msg);
  return 0;
}
