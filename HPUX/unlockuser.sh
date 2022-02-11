#!/usr/bin/sh
#Version 0.0.0.0b

USER=$1

#/usr/lbin/getprdef -r > /dev/null 2>&1
/usr/lbin/getprdef

#if [ $? -eq 0 ]

userdbset -d -u $USER auth_failuresuserdbset -d -u $USER auth_failures

/usr/lbin/modprpw -m exptm=0,lftm=0,mintm=0,expwarn=0,llog=0 $USER
/usr/lbin/modprpw -k $USER
