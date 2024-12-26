// 2044977/bug/55303866
// RUN: %timeout_cmd 90 %c_compiler -O3 %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd 90 %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
;
char a;
unsigned long b;
int c(char d) { return 0; };
int func_53_p_55;
char j(void) {
  short l;
  long __trans_tmp_2;
  char p_56;
  for (a = 0; a <= 7; a += 1) {
    short l_90;
    for (l_90 = 0; l_90 <= 7; l_90 += 1)
      for (p_56 = 0; p_56 != 6; ++p_56) {
        unsigned long *e = &b;
        int l_123;
        for (b = 0; b < 21; b++) {
          {
            __trans_tmp_2 = *e;
            {
              {
                l = ((p_56 || __trans_tmp_2)) ? __trans_tmp_2
                                              : (__trans_tmp_2 << p_56);
              }
              if (l)
                return func_53_p_55;
            }
          }
          for (l_123 = 1; (l_123 >= 0); l_123 -= 1)
            ;
        }
      }
  }
  return p_56;
}
int main(int argc, char *argv[]) { ; }
