#!/bin/bash

set -x
grep -i '^Message-id' | cut -d ' ' -f2 | tr -d '><' | while read l;
do
  nohup notmuch "$@" id:$l >/dev/null 2>/dev/null &
done

