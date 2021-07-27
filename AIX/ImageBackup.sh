#!/usr/bin/ksh
####################################################################################
# Script de Criacao de Image Backup
#
# Autor:Hernani Pires Neto (hernani.pneto@gmail.com)
# Data: 19/04/2013
# Versao 0.0.0.1d
####################################################################################

#Paramentros para gerar o IMAGE
#nimger01 /export/nim/mksysb

#Variaveis de Diretorios
DIR=/images
REMOTEDIR=$2

#VARIAVEIS Globais
DATA=$(date +%Y%m%d)
HORA=$(date +%H%M%S)
HOST=$(uname -n)
LOG=$DIR/log/$HOST.$DATA.log
NULL='/dev/null'
CHECK=""

#Grupos de Funcoes

function desmontaNFS {

        nohup umount -f $DIR >> $NULL 2>&1
        sleep 10
        ps -ef |grep umount |grep -v grep

        if [ $? -eq 0 ]
                then
                        ps -ef |grep umount |grep -v grep |awk '{ print $2 }'|xargs kill -9
        fi

}


#Identificacao do NIM Server
SITE=$1
if [ "$SITE" != '' and "$REMOTEDIR" != '' ]
        then

            #Verifica se o NIM Server esta cadastrado no hosts
            STRINGHOSTS=$(grep "$SITE" /etc/hosts)
                #STRINGHOSTS=$(cat /etc/hosts|grep $(echo "\t$SITE"))

            if [ $? -eq 0 ]
                        then

                            #Verifica se o NIM Server esta respondendo na REDE
                            #echo $STRINGHOSTS
                            IPSITE=$(echo $STRINGHOSTS|awk '{print $1}')
                                #echo $IPSITE
                            ping -c1 $IPSITE > $NULL 2>&1

                                if [ $? -eq 0 ]
                                        then

                                                #Testa o ponto de montagem do IMAGE
                                                showmount -e $SITE|grep -w $REMOTEDIR > $NULL 2>&1

                                                if [ $? -eq 0 ]
                                                        then

                                                                #Montando estrutura NFS para gerar IMAGE BACKUP
                                                                mount -o retry=5,timeo=300,retrans=35,soft,intr $SITE:$REMOTEDIR $DIR > $NULL 2>&1

                                                                if [ $? -eq 0 ]
                                                                        then

                                                                                echo "############################################" >> $LOG
                                                                                echo "# Iniciando Geracao do Image $DATA - $HORA #" >> $LOG
                                                                                echo "# exclude.rootvg                           #" >> $LOG

                                                                                # Arquivo exclude.rootvg
                                                                                cat /etc/exclude.rootvg >> $LOG 2>&1
                                                                                mksysb -i -X -e -p $DIR/$HOST\_$DATA.mksysb  >> $LOG 2>&1

                                                                                if [ $? -eq 0 ]
                                                                                        then
                                                                                                echo " Tamaho do IMAGE $(du -sm $DIR/$HOST\_$DATA.mksysb | awk '{print $1}')" >> $LOG 2>&1
                                                                                                CHECK=`cat $LOG | grep 100% | awk {'print $5'}`

                                                                                                if [ $CHECK == "(100%)" ]
                                                                                                then
                                                                                                cat $LOG
                                                                                                desmontaNFS
                                                                                                exit 0
                                                                                                else
                                                                                                cat $LOG
                                                                                                desmontaNFS
                                                                                                exit 1
                                                                                                fi

                                                                                        else
                                                                                                echo " Image gerado com erro" >> $LOG 2>&1
                                                                                                cat $LOG
                                                                                                desmontaNFS
                                                                                                exit 1
                                                                                fi
                                                                        else

                                                                                echo "#######################################################"
                                                                                echo "# Erro ao montar o NFS.                               #"
                                                                                echo "# Efetuar montagem manual                             #"
                                                                                echo "#######################################################"
                                                                                exit 1
                                                                fi

                                                        else
                                                                echo "#######################################################"
                                                                echo "# Ponto de Montagem Nao Corresponde                   #"
                                                                echo "# Verifique o NIM Server                              #"
                                                                echo "#######################################################"
                                                                exit 1
                                                fi

                                        else
                                            echo "#######################################################"
                                            echo "# NIM Server nao responde.                            #"
                                            echo "# Verifique Problemas de Rede ou parametro incorreto  #"
                                            echo "#######################################################"
                                            exit 1
                                fi

                        else
                            echo "#######################################################"
                            echo "# Efetue o cadastro do servidor no /etc/hosts         #"
                            echo "# Ex: <IP>    <Servidor>                              #"
                            echo "#######################################################"
                            exit 1
                fi

        else
                echo "#########################################################################"
                echo "# Informe o Servidor onde deve ser executado o Backup                   #"
                echo "# Ex: /usr/local/sbin/imageBackup.sh <NIM Server> <'Ponto de Montagem'> #"
                echo "#########################################################################"
                exit 1
fi
