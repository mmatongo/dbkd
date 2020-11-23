#!/bin/bash

set -x
grep -i '^Message-id' | cut -d ' ' -f2 | tr -d '><' | while read l;
do
  notmuch "$@" id:$l
done | less

