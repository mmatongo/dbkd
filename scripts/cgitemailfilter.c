// by p4bl0 <http://pablo.rauzy.name/>, public domain

#include <stdio.h>

int
main (int argc, char *argv[])
{
  signed char flag = 0, c;
  while (EOF != (c = getchar())) {
    switch (c) {
    case '@':
      fputs(" _at_ ", stdout);
      flag = 1;
      break;
    case '.':
      if (flag) {
        fputs(" .dot. ", stdout);
        break;
      }
    default:
      putchar(c);
    }
  }
  return 0;
}
