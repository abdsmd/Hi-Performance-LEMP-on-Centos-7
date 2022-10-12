#!/bin/bash
#ps -ef | grep -v grep | grep mysqld
# Enable continue if any error
set +e

##################################################################
## MySQL
##################################################################
SERVICE="mysqld";
V=$(pidof $SERVICE);
if [ ${#V} -eq 0 ]; then
        echo "Service $SERVICE not running";
        systemctl start $SERVICE
fi
##################################################################


##################################################################
## NGINX
##################################################################
SERVICE="nginx";
V=$(pidof $SERVICE);
if [ ${#V} -eq 0 ]; then
        echo "Service $SERVICE not running";
        systemctl start $SERVICE
fi
##################################################################


##################################################################
## PHP-FPM
##################################################################
SERVICE="php-fpm";
V=$(pidof $SERVICE);
if [ ${#V} -eq 0 ]; then
        echo "Service $SERVICE not running";
        systemctl start $SERVICE
fi
##################################################################


##################################################################
## CROND
##################################################################
SERVICE="crond";
V=$(pidof $SERVICE);
if [ ${#V} -eq 0 ]; then
        echo "Service $SERVICE not running";
        systemctl start $SERVICE
fi
##################################################################


##################################################################
## SSHD
##################################################################
SERVICE="sshd";
V=$(pidof $SERVICE);
if [ ${#V} -eq 0 ]; then
        echo "Service $SERVICE not running";
        systemctl start $SERVICE
fi
##################################################################
# Unset
set -e
sleep 5
nice /watchdog.sh &
exit 0
