// 2044977/bug/55942184
// RUN: %timeout_cmd %timeout_compile %c_compiler -O1 %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
#define a(b) safe_##b
int a, e;
int *b;
char d[6][1][8];
unsigned char c;
int a(rshift_func_int32_t_s_s)(int g, int h) { return h ?: g; }
int au(void) {
  for (;; c++) {
    int f;
    for (; a;)
      for (f = 0; f <= 0; f++)
        if (safe_rshift_func_int32_t_s_s(d[c + 2][f][c + 2], d[4][f][c + 1]))
          *b = e;
  }
}
int main(int g, char *h[]) {}

