#!/bin/bash

NEW_MAIL=~/temp/new_mail

if [ -f $NEW_MAIL ]
then
  while true
  do
    nice ionice -c 3 chrt --idle 0 /bin/sh -c "notmuch new"
    # in case an encryption key is now available
    nice ionice -c 3 chrt --idle 0 /bin/sh -c \
      "PINENTRY_USER_DATA=none notmuch reindex tag:encrypted and not tag:encrypted-failed and not property:index.decryption=success" < /dev/null
    sleep 1
    inotifywait $NEW_MAIL
  done
fi

