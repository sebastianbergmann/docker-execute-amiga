#!/bin/bash
#
# This file is part of docker-execute-amiga.
#
# (c) Sebastian Bergmann <sb@sebastian-bergmann.de>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

usage() {
    echo "Usage: $0 [path] <executable>"
    exit 1
}

if [[ ! -f "$1"  && ( ! -d "$1" || ! -f "$1/$2" ) ]]; then
    echo "$1 not found"
    usage
fi

amiga=$(mktemp -d)

mkdir "$amiga/C"

mkdir "$amiga/S"

if [ -f "$1" ]; then
    cp  "$1" "$amiga/C"
    echo "C:$1" > "$amiga/S/startup-sequence"
elif [ -d "$1" ]; then
    cp -r "$1" "$amiga/C"
    echo "C:$1/$2" > "$amiga/S/startup-sequence"
fi

docker run -it \
  -e DISPLAY="$DISPLAY" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$HOME"/.config/fs-uae/:/home/fsuae/config \
  -v "$amiga":/amiga \
  jamesnetherton/fs-uae \
  --amiga_model=A1200 \
  --hard_drive_0=/amiga \
  > /dev/null

rm -rf "$amiga"

