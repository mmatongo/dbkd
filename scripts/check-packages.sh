#!/bin/bash

# ~/config/private/apt/machines contains lines of the form:
# HOSTNAME file1 file2 file3

comm -3 <(apt-mark showmanual | sort) \
  <(grep "^`hostname | cut -d'.' -f1`" ~/config/private/apt/machines |
    cut -d ' ' -f2- | tr ' ' '\n' | grep -v '^\s*$' |
    sed "s_^_$HOME/config/apt/_" | xargs sort |
    cut -d ' ' -f1 | cut -d '#' -f1 |
    grep -v '^\s*$' | sort | uniq)
