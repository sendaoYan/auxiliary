// 2044977/bug/55242192
// RUN: %timeout_cmd 90 %c_compiler -O2 %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd 90 %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
#define a(b) safe_##b
char a(lshift_func_int8_t_s_s);
int c = 3, f, h;
char d;
char g;
char i;
short j(void);
unsigned long k(void);
int *l(int *);
char m(void) {
  j();
  return 4;
}
short j(void) {
  k();
  return i;
}
unsigned long k(void) {
  l(&c);
  return f;
}
int *l(int *n) {
  for (h = -8; h < 4; h++) {
    int e;
    for (d = 0; d <= 4; d++)
      if ((safe_lshift_func_int8_t_s_s <= (g = h)) <= (*n != 0))
        ;
      else
        return n;
  }
  return n;
}
int main(int n, char *o[]) { m(); }
