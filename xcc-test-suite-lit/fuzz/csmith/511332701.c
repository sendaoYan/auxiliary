// 2044977/bug/55524445 
// RUN: %timeout_cmd %timeout_compile %c_compiler -O2 %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t

long a;
char volatile b, c;
int d;
unsigned char e(void);
char f(void) {
  e();
  return 0;
}
unsigned char e(void) {
  int g;
  char h;
  unsigned short i;
  for (i = 7; i != 1; ++i) {
    if (b)
      a = i;
    h = i >= 2 ? 1 : 1 << i;
    g = h && 7 / h ? 2 : h;
    if (g)
      ;
    else
      return c;
  }
  return d;
}
int main(int argc, char *argv[]) { f(); }

