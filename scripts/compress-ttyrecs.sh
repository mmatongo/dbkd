#!/bin/bash

find ~/logs/ttyrec -name '*.log' -mtime +7 | xz --files
