// 2044977/bug/55258842
// RUN: %timeout_cmd 90 %c_compiler -O3 -fuse-ld=lld -flto=thin %s -o %t
// RUN: %timeout_cmd %timeout_run %t
// RUN: %timeout_cmd 90 %c_compiler %OPTFLAGS %s -o %t
// RUN: %timeout_cmd %timeout_run %t
struct {
  short a;
  unsigned short b;
} c;
unsigned short d;
unsigned short *const e = &c.b;
int f, g, h;
int i(void) {
  h = 5;
  unsigned short *j = &d;
  g = j == e;
  for (d = 0; d <= 60; ++d)
    h = g |= h;
  return f;
}
int main(int argc, char *argv[]) {}
