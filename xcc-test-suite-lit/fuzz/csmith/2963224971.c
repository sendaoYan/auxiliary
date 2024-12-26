// 2044977/bug/55077250
// RUN: %timeout_cmd 90 %c_compiler -O3 %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd 90 %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
int a, b;
char c;
long d;
short e, f;
char g(void) {
  for (e = 0; e <= 8; e++) {
    for (a = 2; a <= 8; a++)
      ;
    for (c = 3; c <= 8; c++) {
      long h = 0;
      for (d = 0; d <= 8; d++)
        for (b = 8; b; b--) {
          h |= f;
          if (h)
            continue;
          return 1;
        }
    }
  }
  for (;;)
    ;
}
int main(int argc, char *argv[]) {}
