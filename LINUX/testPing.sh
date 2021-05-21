for i in $(cat lst.dr);
do
    ping -c 1 -W 1 $i
    PING=$?
    if [ 0 -eq $PING ]
    then
        grep -iw $i /etc/hosts >> servers.dr
    else
        echo "Server $i sem comicacao em producao" >> noservers.dr
    fi
done