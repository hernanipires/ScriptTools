#!/usr/bin/sh

while true;

do
  ps -ef|grep -v grep |grep -w "/usr/sbin/getty /dev/console"
  if [ $? -ne 0 ]
  then
    nohup /usr/sbin/getty /dev/console > /dev/null
  fi
  sleep 5
done
