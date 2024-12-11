long d(int, void *, unsigned) __attribute__((__access__(__write_only__, 2, 3)));
void i(const char *, int, const char *, const char *);
const char *c[0];
void j(int k) {
  char *a;
  for (const char **e = c; e;) {
    char *f = 0;
    long g = k;
    a = f;
    unsigned b = g;
    if (b)
      i("", 5, "", "");
    long h = d(0, a, b);
    if (h) {
    }
  }
}
