#include <stdio.h>

int main(int argc, char const *argv[]) {
  /* code */
  // int b = 108000;
  // int c = 125100;
  int b = 81;
  int c = 81;
  int g = 0;
  int h = 0;

  do {
    int f = 1;
    int d = 2;

    do {
      int e = 2;
      do {
        g = d*e-b;

        if (g==0) {
          f = 0;
        }

        e++;
        g = e - b;
      } while(g != 0);

      d++;
      g = d - b;
    } while(g != 0);

    if (f == 0) {
      h++;
    }

    g = b - c;
    if (g == 0) {
      printf("%i\n", h);
      return 0;
    }

    b +=17;
  } while(g != 0);

  return 0;
}
