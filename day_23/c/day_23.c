#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int is_prime(int number)
{
     if (number <= 1) return 0;
     if (number % 2 == 0 && number > 2) return 0;
     for(int i = 3; i <= (int)ceil(sqrt(number)); i+= 2)
     {
         if (number % i == 0)
             return 0;
     }
     return 1;
}

int main(int argc, char const *argv[]) {
  int h = 0;
  int b = 108100;
  int c = 125100;

  for (; b <= c; b+=17) {
    if (!is_prime(b)) {
      ++h;
    }
  }

  printf("Number of none primes in steps of size 17 between %i and %i is: %i\n", b, c, h);

  return 0;
}
