#!/usr/bin/sh

#Estrutura com uptime ultimo reinicio, gerar info antes do Reinicio, configurar crontab

mount |awk '{print $1}'|sort -n > mount-$(date +%F%s).mnt


grep -Ev "^#|^$" /etc/fstab |awk '{print $2}'|sort -n > mount-$(date +%F%s).mnt 

diff $LAST1 $LAST2
