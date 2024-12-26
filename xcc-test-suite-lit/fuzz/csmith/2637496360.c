// 2044977/bug/55353301	
// RUN: %timeout_cmd %timeout_compile %c_compiler -O1 %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
static long a[1];
int b, e;
short c;
char d;
long f;
int *i(void) {
  int g;
  for (;;) {
    int *h = &e;
    for (; c;)
      ;
    for (e = 5; e >= 0; e--)
      ;
    for (g = 5; g >= 0; g--) {
      d = a[0];
      if ((long)~*h > g | d < g)
        ;
      else
        return &b;
    }
  }
}
short j(void) {
  i();
  return f;
}
int main(int argc, char *argv[]) { j(); }
