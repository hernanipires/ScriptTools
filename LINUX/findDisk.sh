#!/usr/bin/sh

unalias ls
for i in $(ls /sys/class/scsi_host/);
do
	echo "- - -" > /sys/class/scsi_host/$i/scan

done
