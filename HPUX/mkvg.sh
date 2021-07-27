
mkdir /dev/datof0vg
mknod /dev/datof0vg/group c 128 0x100000
vgcreate -V 2.0 -s 256M -S 20t /dev/datof0vg /dev/disk/disk130


#Creacion LV
/usr/sbin/lvcreate   -l	160	-p w -s	y -A y	-n gridlv oravg && /usr/sbin/lvchange  -t 0 -a y	/dev/oravg/gridlv

#Extend LV extends
/usr/sbin/lvextend	-A y -l	127 /dev/vgindprd/lvdatind01

#Creacion del filesystem
/sbin/mkdir -p -m u=rwx,g=rx,o=rx /u01/app/grid && /usr/sbin/mkfs -F vxfs   /dev/oravg/gridlv

/usr/sbin/mount -F vxfs -e  /dev/oravg/gridlv /u01/app/grid && /usr/bin/cp -p /etc/fstab /etc/fstab.smh.old && /usr/bin/echo "/dev/oravg/gridlv	/u01/app/grid	vxfs defaults 0	2"  >> /etc/fstab
