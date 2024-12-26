// RUN: %timeout_cmd %timeout_compile %cxx_compiler -O2 %s -o %t && %timeout_cmd %timeout_run %t "hello C++" | %FileCheck %s
// RUN: %timeout_cmd %timeout_compile %cxx_compiler %s %OPTFLAGS -o %t && %timeout_cmd %timeout_run %t "hello C++" | %FileCheck %s
//CHECK: hello C++

#include <iostream>
int main(int argc, char** argv) {
  std::cout << argv[1] << std::endl;
  return 0;
}
