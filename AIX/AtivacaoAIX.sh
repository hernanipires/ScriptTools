#!/usr/bin/sh
##################################
#Hernani Pires
#Ativacao Servidores
#Version 0.0.0.1
##################################


#Executar o Varyon nos VGs
for i in $(lsvg);
do
    echo $i
    varyonvg -O $i
done

#Montar os Filesystems
for i in $(lsvg -o|grep -v root);
do
    mount -t $(echo $i |rev |cut -c 3-|rev)
done


#Montar os Filesystems
for i in $(lsvg -o|grep -v root);
do
    for j in $(lsvg -l $i|grep closed|awk '{print $NF}')
    do
      fsck $j
      mount $j
    done
done

#Listar LDEV "Hitachi"
for i in $(lsdev -Cc disk -F name);do echo $i $(lscfg -vpl $i|grep Z1 |sed 's/\./\ /g');done|awk '{print $1" "$5}'


for i in $(lsvg -p TRONVG02|awk '{print $1}');do echo $i $(lspv -l $i|grep prod_system) $(lscfg -vpl $i|grep Z1 |sed 's/\./\ /g'|awk '{print $4}');done|grep prod_system|awk '{print $1" "$2" "$7}'

chdev -l en0 -a netaddr=$(cat netaddr.vip)

mount -n produccion2 -o bg,hard,rsize=32768,wsize=32768,vers=3,proto=tcp /dbarchivesXM /dbarchives

#Export nfs
/usr/sbin/mknfsexp -d '/NFIPXM' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/usr/local/apache-tomcat-5.5.26/logsXM' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/usr/appsXM' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/apXM' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/apXM/lis/imprenta' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/apXM/lis/pcl_batch' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/catalinaXM' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/dbarchivesXM' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/export_areaXM' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/ftp_areaXM' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/home/ftpp20XM' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

/usr/sbin/mknfsexp -d '/workareaXM/DataTran/EMAILGEN/TW' '-P' '-N' -S 'sys,krb5p,krb5i,krb5,dh' -t 'rw'

grep -i oracle /etc/passwd|cut -d: -f1|xargs -I [] echo "[]:Mapfre@123"|chpasswd -c


/usr/DynamicLinkManager/bin/dlnkmgr view -lu|grep ^0|awk '{print $2"\t"$1}'|sort -n

#Limpar discos em DR
for i in $(lsdev -Cc disk -F name);do rmdev -dl $i;done

lquerypv -h /dev/ASM0002 20 10

DSK=0
for i in $(lspv|grep none|awk '{print $1}'); do rendev -l $i  -n ASM0$DSK;DSK=$(echo "$DSK + 1"|bc);done


chdev -l inet0 -a route="net,-hopcount,0,-netmask,255.255.255.0,,,,,-static,10.119.249.0,192.168.220.1"
