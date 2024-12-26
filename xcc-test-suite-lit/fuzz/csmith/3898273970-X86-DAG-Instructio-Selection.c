// 2044977/bug/55959485
// RUN: %timeout_cmd %timeout_compile %c_compiler -O1 %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd %timeout_compile %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
char a[6][1][8];
unsigned char b;
int c;
void d(void) {
  for (;; b++) {
    int e;
    for (; c;)
      for (e = 0; e <= 0; e++)
        a[0][b][b + 7] = a[b + 2][e][b + 2];
  }
}
int main(int argc, char *argv[]) {}

