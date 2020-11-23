#!/usr/bin/python3 -u

# TODO: should remove non-printable chars

import sys

sys.stdin = sys.stdin.detach()
sys.stdout = sys.stdout.detach()

try:
  while True:
    l = sys.stdin.readline()
    if not l:
      break
    try:
      line = l.decode('utf8')
    except UnicodeDecodeError:
      line = l.decode('latin1')
    sys.stdout.write(line.encode('utf8'))
except IOError:
  pass
