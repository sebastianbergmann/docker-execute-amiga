#!/bin/bash
#
# This file is part of docker-execute-amiga.
#
# (c) Sebastian Bergmann <sb@sebastian-bergmann.de>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

if [ -z $1 ]
  then
    echo "$0 <executable>"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "$1 not found"
    exit 1
fi

amiga=`mktemp -d`

mkdir "$amiga/C"
cp $1 "$amiga/C"

mkdir "$amiga/S"
echo "C:$1" > "$amiga/S/startup-sequence"

docker run -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/.config/fs-uae/:/home/fsuae/config \
  -v $amiga:/amiga \
  jamesnetherton/fs-uae \
  --amiga_model=A1200 \
  --hard_drive_0=/amiga \
  > /dev/null

rm -rf $amiga

