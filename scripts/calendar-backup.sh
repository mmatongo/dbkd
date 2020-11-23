#!/bin/bash

set -e

# run with chronic to avoid spam

cd /mnt/mem/backup/calendar # required to have the right paths in the archive

# avoid "file changed as we read it" errors from tar
cp -R calendar_current calendar_backup
FILE="dump-`date +%s`"
tar cf ${FILE}.tar calendar_backup
xz ${FILE}.tar
rm -Rvf calendar_backup

