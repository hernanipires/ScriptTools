#!/usr/bin/sh
##################################
#Hernani Pires
#Ativacao Servidores
#Version 0.0.0.1
##################################


#Executar o Varyon nos VGs
for i in $(lspv |grep vg|awk '{print $3}'|sort -n|uniq|grep -v root);
do
    varyonvg $i
done

#Montar os Filesystems
for i in $(lsvg -o|grep -v root);
do
    mount -t $(echo $i |rev |cut -c 3-|rev)
done
