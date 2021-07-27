#!/usr/bin/sh
for i in $(ioscan -fnC fc|grep dev);do
        PN=$(/opt/fcms/bin/fcmsutil $i|grep "N_Port Port"|awk '{print $7}');
        NN=$(/opt/fcms/bin/fcmsutil $i|grep "N_Port Node"|awk '{print $7}');
        SUP=$(/opt/fcms/bin/fcmsutil $i|grep "NPIV Supported"|awk '{print $4}');
        LINK=$(/opt/fcms/bin/fcmsutil $i|grep "Link Speed"|awk '{print $4}');
        DRV=$(/opt/fcms/bin/fcmsutil $i|grep "Driver state"|awk '{print $4}');
        echo "$i $PN $NN $SUP $DRV";
done
