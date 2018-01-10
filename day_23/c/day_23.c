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
        if (d*e==b) {
          f = 0;
        }

        e++;
      } while(e != b);

      d++;
    } while(d != b);

    if (f == 0) {
      h++;
    }

    b +=17;
  } while(b - c - 17 != 0);

  printf("%i\n", h);
  return 0;
}
