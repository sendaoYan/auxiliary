// 2044977/bug/55065879
// RUN: %timeout_cmd %timeout_compile %c_compiler -O3 %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
int a, b;
long c;
int **d, **f;
int ***e = &d;
int *g;
short h;
int **j(int **);
char k(void) {
  f = j(&g);
  *e = f;
  *d = 0;
  return 0;
}
int **j(int **l) {
  for (h = 0; h < 31; ++h) {
    int i;
    for (a = 0; a <= 5; a++)
      for (i = 0; i < 2; i++)
        if (h < 3) {
          long *m = &c;
          *m = h;
        } else
          return l;
    for (b = 9; b; b--)
      ;
  }
  for (;;)
    ;
}
int main(int l, char *n[]) { k(); }
