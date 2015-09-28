#!/bin/bash
#Author:        Kylin
#Date:          2015/9
#usage for:     Configure hostname

. /etc/rc.d/init.d/functions

HOSTNAME=/etc/hostname
HOSTS=/etc/hosts

function Configure_Hostname {
        echo -e "\e[1;32m********Your server's configuration look like: \e[0m"
        hostnamectl status
        echo -n -e "\e[1;34mEnter the hostname you want: \e[0m"
        read HOST_NAME
        echo "$HOST_NAME" > $HOSTNAME
        sed -i "1{s/$/ $HOST_NAME/}" $HOSTS
        sed -i '1s#localhost#localhost $HOST_NAME.localdomain#' $HOSTS

}

#Call the function
Configure_Hostname

echo -e "\e[1;32mIt's OK. You can logout and then login to check! \e[0m"
