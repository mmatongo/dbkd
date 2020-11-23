#!/bin/bash

# https://unix.stackexchange.com/q/397136

apt-get -s autoremove -qq \
  -o Apt::AutoRemove::RecommendsImportant=false \
  -o Apt::AutoRemove::SuggestsImportant=false |
  grep '^Remv' | cut -d' ' -f2 | sort

