#!/bin/bash
#Author:        Kylin
#Date:          2015/9/1
#Usage for:     Configure network

. /etc/rc.d/init.d/functions

function CON_NETWORK_With_Text_Mode {
        ip addr
        echo -n -e "\e[1;34mEnter the name of your network card: \e[0m"
        read NET_CARD
        while [ ! -f "/etc/sysconfig/network-scripts/ifcfg-$NET_CARD" ] ; do
                echo -e "\e[1;31mYou enter the wrong name of network card!!\e[0m"
                ip addr
                echo -n -e "\e[1;34mEnter the name of your network card,again: \e[0m"
                read NET_CARD
        done

        #Configure static ip and start network automatically
        NET_CARD_CONF=/etc/sysconfig/network-scripts/ifcfg-${NET_CARD}
        cp $NET_CARD_CONF $NET_CARD_CONF.bak
        sed -i '/^ONBOOT/c \ONBOOT="yes"' $NET_CARD_CONF #Replace all line 
        sed -i '/^BOOTPROTO/c \BOOTPROTO="static"' $NET_CARD_CONF #Replace all line 

        #Enter configuration
        while true ; do
                echo -n -e "\e[1;34mEnter the static IP Address: \e[0m"
                read IP_ADDR
                echo -n -e "\e[1;34mEnter the NETMASK,default is 255.255.255.0 : \e[0m"
                read NET_MASK
                echo -n -e "\e[1;34mEnter the GATEWAY: \e[0m"
                read GATE_WAY
                echo -n -e "\e[1;34mEnter the DNS1: \e[0m"
                read DNS1
                echo -n -e "\e[1;34mEnter the DNS2: \e[0m"
                read DNS2

                echo -e "\e[1;36m*******Check the Input*******\e[0m"
                echo -e "\e[1;36m       IPADDR=$IP_ADDR\e[0m"
                echo -e "\e[1;36m       NETMASK=$NET_MASK\e[0m"
                echo -e "\e[1;36m       GATEWAY=$GATE_WAY\e[0m"
                echo -e "\e[1;36m       DNS1=$DNS1\e[0m"
                echo -e "\e[1;36m       DNS2=$DNS2\e[0m"


                echo -n -e "\e[1;34mEnter yes to continue, Enter no to input again: \e[0m"
                read CHECK
                if [ $CHECK == 'yes' ] ; then
                        break;
                fi
        done

        cat >> $NET_CARD_CONF <<EOF
                IPADDR=$IP_ADDR
                NETMASK=$NET_MASK
                GATEWAY=$GATE_WAY
                DNS1=$DNS1
                DNS2=$DNS2

EOF

        #Restart network service
        systemctl restart network

        #Check wheater network is working
        if [ `systemctl status network | awk -F ' ' 'NR==3 {print $2}'` == 'active' ] ; then
                action "Network service on: " /bin/true
        else
                action "Network service on: " /bin/false
        fi

}

function CON_NETWORK {
echo -e "\e[1;32m*****Configure Network with Static IP Address***** \e[0m"
cat <<EOF
        There are two ways to configure IP Address:
                1.With User Interface
                2.With textmode
EOF
echo -n -e "\e[1;34mEnter your choice: \e[0m"
read CON_CHOICE

case $CON_CHOICE in
        1)
                nmtui 
                ;;
        2)
                CON_NETWORK_With_Text_Mode
                ;;
        *)
                echo -e '\e[1;31;1mInvalid choice. \e[0m'
                echo -n -e "\e[1;34mEnter yes to reconfig network, or no to jump off: \e[0m" 
                read RECON_NETWORK
                if [[ $RECON_NETWORK == 'yes' ]] ; then
                        CON_NETWORK
                fi
esac
}

CON_NETWORK