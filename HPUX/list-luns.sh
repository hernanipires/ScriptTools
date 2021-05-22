#!/usr/bin/sh
# Hernani Pires
# Fecha 24/02/2020 - Version 2.5.1
# Discos Hitachi

#Crear funcion para scanear os discos
#ioscan -fnC disk

TOTAL=0
printf "%-8s %-6s %-5s %-17s %-13s %-1s \n" "STORAGE" "LDEV" "SIZE" "DISK" "USED" "VG"
for i in $(ioscan -fNkC disk|grep -Ev "^=|^C"|awk '{print $2}');
do
  RAW="/dev/rdisk/disk$i"
  SIZE=$(echo  "$(diskinfo $RAW|grep size|awk '{print $2}') / 1024 / 1024"|bc)
  ID=$(scsimgr lun_map -D $RAW |grep -E "WWID"|cut -d= -f2)
  LVM=$(pvdisplay -l /dev/disk/disk$i|cut -d: -f2)
  UUID=$(echo $ID|tail -c 5|tr '[:lower:]' '[:upper:]')
  STRG=$(echo "obase=10; ibase=16; $(echo $ID|cut -c 22-26|tr '[:lower:]' '[:upper:]')"|bc)
  DISK="/dev/disk/disk$i"
  VG=$(pvdisplay $DISK 2> /dev/null|grep "VG N"|cut -d"/" -f3)
  printf "%-8s %-6s %-5s %-17s %-13s %-1s \n" "${STRG}" "${UUID}" "${SIZE}" "${DISK}" "${LVM}" "${VG}"
  #TOTAL=$(echo $SIZE + $TOTAL|bc)
done

#printf "Total Alocado = ${TOTAL} G"

#Implementar esse ajuste
#vgdisplay -v|grep -E "VG N|PV N"




#cat disk_2021-02-25.1614295137.txt|awk '{print $2}'|sort -n > LDEVs.norte
#cat disk_dr|awk '{print $2}'|sort -n > LDEVs.sur
#ls
#diff LDEVs.norte LDEVs.sur
