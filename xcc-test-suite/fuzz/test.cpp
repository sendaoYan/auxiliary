// RUN: %cpp -O2 %s -o %t && %t "hello C++" | %FileCheck %s
// RUN: %cpp %s %OPTFLAGS -o %t && %t "hello C++" | %FileCheck %s
//CHECK: hello C++

#include <iostream>
int main(int argc, char** argv) {
  std::cout << argv[1] << std::endl;
  return 0;
}
