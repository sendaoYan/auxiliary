// 2044977/bug/55462718
// RUN: %timeout_cmd %timeout_compile %c_compiler -O3 %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
#define a(b) safe_##b
char c, g, m;
int e, n, l;
unsigned char h;
int *k;
long j;
char a(add_func_int8_t_s_s)(void) { return c; }
char a(mul_func_uint8_t_u_u)(char p, char q) { return p * q; }
int **o(char *p) {
  m = *p;
  return &k;
}
static long aa(long p, char *q) {
  unsigned long a[3];
  for (;; safe_add_func_int8_t_s_s()) {
    int i;
    for (; l;)
      for (; g; g++) {
        if (*q == n <= a[2]) {
          unsigned long *b = &a[2];
          *b = j;
          return 2;
        }
        *k = safe_mul_func_uint8_t_u_u(*q, p);
      }
  }
}
short ag(void) {
  unsigned char *d = &h;
  char f = 10;
  *d = e;
  aa((f ^= h) == e, &h);
  o(&f);
  return 2;
}
int main(int p, char *q[]) {}

