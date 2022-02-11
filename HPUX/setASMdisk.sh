#!/usr/bin/sh

#Global
LIB=/usr/local/sclib/dsk.lst
LDK=/usr/local/sclib/filDSK.lst
USER=$1

/usr/local/sbin/list-luns > $LIB
touch $LDK

for DISK in $(cat $LIB|grep "LVM_Disk=no"|awk '{print $4}');
do
  /usr/sbin/diskowner $DISK 2> $LDK;
  /usr/bin/grep asm $LDK;
  if [ $? -eq 0 ];
  then
    chown "$USER:oinstall" $(awk '{print $2}' $LDK | sed "s/\/disk\//\/rdisk\//g")
    chmod 660 $(awk '{print $2}' $LDK | sed "s/\/disk\//\/rdisk\//g")
  fi
done
