
mkdir /dev/datof0vg
mknod /dev/datof0vg/group c 128 0x100000
vgcreate -V 2.0 -s 256M -S 20t /dev/datof0vg /dev/disk/disk130


#Creacion LV
/usr/sbin/lvcreate   -l	6165	-p w -s	y -A y	-n ofic0lv datof0vg && /usr/sbin/lvchange  -t 0 -a y	/dev/datof0vg/ofic0lv

#Extend LV extends
/usr/sbin/lvextend	-A y -l	127 /dev/vgindprd/lvdatind01

#Creacion del filesystem
/sbin/mkdir -p -m u=rwx,g=rx,o=rx /ofic0 && /usr/sbin/mkfs -F vxfs /dev/datof0vg/ofic0lv

/usr/sbin/mount -F vxfs -e  /dev/datof0vg/ofic0lv /ofic0 && /usr/bin/cp -p /etc/fstab /etc/fstab.sclib && /usr/bin/echo "/dev/datof0vg/ofic0lv	/ofic0	vxfs defaults 0	2"  >> /etc/fstab
