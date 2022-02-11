

for i in $(lsdev -Cc disk -F name);
do
  STORAGE=$(echo "ibase=16; $(lscfg -vpl $i|grep "Serial Number"|awk '{print $NF}')"|bc);
  LDEV=$(lscfg -vpl $i|grep Z1|sed 's/\./\ /g'|awk '{print $4}');
  SIZE=$(echo "$(bootinfo -s $i) / 1024" |bc)
  VG=$(lspv|grep -w "$i "|awk '{print $3}')

  echo "$STORAGE\t$LDEV\t$SIZE\t$i  \t$VG";

done
