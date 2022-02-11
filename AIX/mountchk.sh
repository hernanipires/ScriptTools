

for i in $(lsvg);do varyonvg $i;done

for i in $(lsvg);do for j in $(lsvg -l $i|awk '{print $NF}');do mount $j;done;done


/usr/local/bin/mutt/bin/mutt -s 'PRUEBA TEST DESDE PRODUCCION2' hernani.neto@telefonica.com

PRODUCCION2_AS is started by /var/hacmp/scripts/sube_todo.sh
PRODUCCION2_AS is stopped by /var/hacmp/scripts/baja_todo.sh


Zoilo Medrano Durán <zmedrano@mapfrepr.com>
