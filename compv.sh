#!/bin/bash

##
## This file is part of tiler, a tileset and scene editor for the VIC20
## Copyright (C) 2023 Nate Smith (nat2e.smith@gmail.com)
##
## tiler is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## tiler is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

#
# This script compiles a 6502 assembly file with 64tass, crunches it with pucrunch,
# and finally runs vice/xvic against it
#
# usage: compv <file> <start-address>
#
# <file> is the asm file
# <start-address> is in hex, like 100A
#
# for example, to assemble myAsmFile.asm with start address $100A:
#
# compv myAsmFile.asm 100A
#

DECIMAL_ADDRESS=$((16#$2))

DISK_9=disk1.d64
DISK_10=disk2.d64

TASS=64tass
EXOMIZER=exomizer
VICE=xvic

FULL_FILENAME=$1
BASE_NAME=${FULL_FILENAME%%.*}

$TASS -C -a -i $FULL_FILENAME -o $BASE_NAME.tmp

retval=$?

if [ $retval -ne 0 ]; then
    printf "\ntass failed\n"
    exit $retval
fi

$EXOMIZER sfx $DECIMAL_ADDRESS -t 52 $BASE_NAME.tmp -o $BASE_NAME.prg

retval=$?
rm -f $BASE_NAME.tmp

if [ $retval -ne 0 ]; then
    printf "\npucrunch failed\n"
    exit $retval
fi

$VICE -memory all -ntsc -chdir $PWD -9 $DISK_9 -10 $DISK_10 $3 $BASE_NAME.prg

retval=$?

if [ $retval -ne 0 ]; then
    printf "\nvice failed\n"
    exit $retval
fi
