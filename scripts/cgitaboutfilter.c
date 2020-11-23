// by p4bl0 <http://pablo.rauzy.name/>, public domain

#include <stdio.h>
#include <string.h>

void
print_html_c (int c)
{
  switch (c) {
  case '<':
    fputs("&lt;", stdout);
    break;
  case '>':
    fputs("&gt;", stdout);
    break;
  case '&':
    fputs("&amp;", stdout);
    break;
  case '"':
    fputs("&quot;", stdout);
    break;
  default:
    putchar(c);
  }
}

void
print_html_s (char *s)
{
  while (*s) print_html_c(*s++);
}

int
main (int argc, char *argv[])
{
  signed char c;
  signed char urlflag;
  char urlbuf[256];
  char *ext = strrchr(argv[1], '.');

  if (NULL == ext) { // plain text
    fputs("<pre>\n", stdout);
    urlflag = -1;
    while (EOF != (c = getchar())) {
      if (urlflag > -1) {
        if ((0 == urlflag && 'h' == c) ||
            (1 == urlflag && 't' == c) ||
            (2 == urlflag && 't' == c) ||
            (3 == urlflag && 'p' == c)) {
          urlbuf[urlflag++] = c;
        } else if (urlflag < 4) { // not an url
          urlbuf[urlflag++] = c;
          urlbuf[urlflag] = 0;
          print_html_s(urlbuf);
          urlflag = -1;
        } else { // indeed an url
          urlbuf[urlflag++] = c;
          while ('>' != (c = getchar())) {
            if ('\n' == c) {
              fputs("BROKEN README\n</pre>", stdout);
              return 1;
            } else {
              urlbuf[urlflag++] = c;
            }
          }
          urlbuf[urlflag] = 0;
          printf("<a href=\"%s\">%s</a>&gt;", urlbuf, urlbuf);
          urlflag = -1;
        }
      } else {
        if ('<' == c) {
          urlflag++;
        }
        print_html_c(c);
      }
    }
    fputs("\n</pre>", stdout);
  } else if (0 == strcmp(".html", ext)) { // html
    while (EOF != (c = getchar())) {
      putchar(c);
    }
  }

  return 0;
}
