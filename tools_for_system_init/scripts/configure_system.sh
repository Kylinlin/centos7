#!/bin/bash
# Author:        kylin
# E-mail:        kylinlingh@foxmail.com
# Blog:          http://www.cnblogs.com/kylinlin
# Github:        https://github.com/Kylinlin
# Date:                  2015/9/9       
# Version:       1.0
# Function:      
################################################

. /etc/rc.d/init.d/functions

function Add_User_As_Root {
        echo -e "\e[1;31mWarning: you are adding a user as root's privilege! yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
                return 0
        fi
        echo -n -e "\e[1;34mEnter the username: \e[0m" 
        read USER_NAME
        #echo -n -e "\e[1;34mEnter the passwd: "
        #read PASSWD
        useradd $USER_NAME
        passwd $USER_NAME
        gpasswd -a $USER_NAME wheel
        echo -e "\e[1;32mEvery command must come after \"sudo\" \e[0m"

        return 0
}

function Change_SSH_Port {
        echo -e "\e[1;34mChange the default port 22 for SSH? yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
                return 0
        fi

        SSH_CONF=/etc/ssh/sshd_config
        cp $SSH_CONF $SSH_CONF.bak
        echo -e "\e[1;34mEnter the port number for SSH(between 1025 to 65536): \e[0m"
        read PORT_NUM
        sed -i "/^#Port 22/c \PORT $PORT_NUM" $SSH_CONF
        sed -i "/^#Protocol 2/c \Protocol 2" $SSH_CONF
        sed -i "/^#PermitRootLogin yes/c \PermitRootLogin no" $SSH_CONF

        #Tell the selinux that ssh port has been changed
        yum install policycoreutils-python-2.2.5-15.el7.x86_64 -y > /dev/null
        semanage port -a -t ssh_port_t -p tcp $PORT_NUM

        #Add the port to firewall
        firewall-cmd --zone=public --add-port=$PORT_NUM/tcp --permanent > /dev/null

        #Check service
        systemctl reload sshd.service
        if [ `systemctl status sshd.service | awk -F ' ' 'NR==3 {print $2}'` == 'active' ] ; then
                action "SSH service on: " /bin/true
        else
                action "SSH service on: " /bin/false
        fi

        return 0
}

function SSH_Authorization {
        echo -e "\e[1;31mWarning: you are configuring to login with ssh authorization instead of password! yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
                return 0
        fi

        SSH_CONF=/etc/ssh/sshd_config
        #cp $SSH_CONF $SSH_CONF.bakk
        sed -i "/^#StrictModes yes/c \StrictModes no $PORT_NUM" $SSH_CONF
        sed -i "/^#RSAAuthentication yes/c \RSAAuthentication yes" $SSH_CONF
        sed -i "/^#PubkeyAuthentication yes/c \PubkeyAuthentication yes" $SSH_CONF
        sed -i "/^AuthorizedKeysFile/c \AuthorizedKeysFile      ~/.ssh/authorized_keys" $SSH_CONF
        sed -i "/^#PasswordAuthentication yes/c \PasswordAuthentication no" $SSH_CONF

        echo -e "\e[1;36mCopy your client's certification to here \e[0m"

}