



ioscan -fnC disk

./list-luns > allDisk.lst

for i in $(cat allDisk.lst|awk '{print $4}');do diskowner $i ;done  2> catDisk.lst

grep asm catDisk.lst > asm.lst

for i in $(cat asm.lst|awk '{print $2}');do grep $i allDisk.lst;done > ldevASM.lst


for i in $(cat ldevASM.lst|awk '{print $4}'|cut -d/ -f4);do chmod 660 /dev/rdisk/$i;chown "grid:oinstall" /dev/rdisk/$i ;done
