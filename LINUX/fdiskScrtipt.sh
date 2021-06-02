#!/bin/bash

#DEVICE="/dev/$1"

DEVICE=$(cat disk.lst)

#DISKID=$(blkid $DEVICE | cut -d' ' -f2 | cut -d\" -f2)

cat <<EOF | fdisk $DEVICE    #reads the disk utiliy
n
p
1


t
83
w
EOF
