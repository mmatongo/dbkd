/* a2freq - convert MIDI note numbers or scientific pitch notations to frequencies */
/* by Antoine Amarilli (2011) */
/* licence: public domain */
/* compilation: cc -lm -o a2freq a2freq.c */

#include <stdio.h>
#include <math.h>
#include <ctype.h>

#define E_ARGS 1
#define E_PARSE 2

int atoi(const char *nptr);


float key2freq(int n)
{
  /* Return frequency of midi note number n, inspired by the "Piano key
   * frequencies" article on wikipedia */

  return 440*pow(2, ((float) (n - 69))/12);
}


int name2num(char name)
{
  /* Return note number adjustment for upper case scientific pitch
   * notation note name name. Return <0 on error. */

  switch(name)
  {
    case 'C':
      return 0;
    case 'D':
      return 2;
    case 'E':
      return 4;
    case 'F':
      return 5;
    case 'G':
      return 7;
    case 'A':
      return 9;
    case 'B':
      return 11;
    default:
      return -1;
  }
}


int accid2num(char accid)
{
  /* Return note number adjustment for scientific pitch notation note
   * accidental. Return 0 on error. */

  switch (accid) {
    case 'b':
      return -1;
    case '#':
      return 1;
    default:
      return 0;
  }
}


int note2num(int octave, int note)
{
  /* Return MIDI note number for octave and note. */

  return (octave + 1)*12 + note;
}


float pitch2freq(char* a)
{
  /* Return frequency of scientific pitch notation note a, by converting
   * it to a key number and using key2freq. Return <0 on parse error. */
 
  // octavepos position where octave indication is expected
  int note, octave = 4, accid, octavepos = 1;

  /* parse note name */
  if (!a[0]) return -1;
  note = name2num(toupper(a[0]));
  if (note < 0) return note;
  
  /* parse accidental */
  if (a[octavepos] && !isdigit(a[octavepos])) {
    accid = accid2num(a[octavepos]);
    if (!accid) return -1;
    note += accid;
    octavepos++;
  }

  /* parse octave */
  return key2freq(!a[octavepos]?
      note2num(octave, note):
      note2num(atoi(a + octavepos), note));
}


float do_one(char* a)
{
  int result;

  if ((result = atoi(a)))
    return key2freq(result);
  else return pitch2freq(a);
}


int main(int argc, char** argv)
{
  int i;
  double result;

  if (argc <= 1) {
    fprintf(stderr,
        "Usage: %s [NOTE]...\n", argv[0]);
    fprintf(stderr,
        "Convert MIDI note numbers or scientific pitch notations to "
        "frequencies.\n");
    fprintf(stderr,
        "NOTE is either a MIDI note number or a key in scientific pitch "
        "notation.\n");
    fprintf(stderr,
        "Scientific pitch notation examples: \"A4\", \"C#2\", " "\"Bb6\"\n");
    return E_ARGS;
  }
      
  for (i=1; i<argc; i++)
  {
    result = do_one(argv[i]);
    if (result >= 0)
      printf("%f\n", result);
    else {
      fprintf(stderr, "a2freq: cannot parse %s\n", argv[i]);
      return E_PARSE;
    }
  }

  return 0;
}

