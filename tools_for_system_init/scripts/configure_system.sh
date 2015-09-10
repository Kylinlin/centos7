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
        echo -n -e "\e[1;31mWarning: you are adding a user as root's privilege! yes or no: \e[0m"
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
        echo -e "\e[1;32mUser $USER_NAME has been added sucessfully! Every command must come after \"sudo\" \e[0m"

        return 0
}

function Change_SSH_Port {
        echo -n -e "\e[1;31m\nWarning: you are changing the port of ssh! yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
                return 0
        fi

        SSH_CONF=/etc/ssh/sshd_config
        if [ -f $SSH_CONF.bak ]; then
                rm -f $SSH_CONF
                mv $SSH_CONF.bak $SSH_CONF
        fi
        cp $SSH_CONF $SSH_CONF.bak
        echo -n -e "\e[1;34mEnter the port number for SSH(between 1025 to 65536): \e[0m"
        read PORT_NUM
        echo  "Please wait for a while..."
        sed -i "/^#Port /c \Port $PORT_NUM" $SSH_CONF
        sed -i "/^Port /c \Port $PORT_NUM" $SSH_CONF
        sed -i "/^#Protocol 2/c \Protocol 2" $SSH_CONF
        sed -i "/^#PermitRootLogin yes/c \PermitRootLogin no" $SSH_CONF
        sed -i "/^PermitRootLogin yes/c \PermitRootLogin no" $SSH_CONF

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

function Secure_Set {
        FIREWALL_STATUS=`systemctl status firewalld | awk -F ' ' 'NR==3 {print $2}'` 
        if [ $FIREWALL_STATUS == 'active' ] ; then
        action "Firewall on: " /bin/true
    else
        action "Firewall on: " /bin/false
    fi

        #Active firewall now?
        echo -n -e "\e[1;34mActive firewall? yes or no: \e[0m"
        read FIREWALL_START
        if [[ $FIREWALL_START == 'yes' && $FIREWALL_STATUS != 'active' ]] ; then
                systemctl start firewalld
                echo -e "\e[1;32mFirewall is actived now\e[0m"
        elif [[ $FIREWALL_START == 'no' && $FIREWALL_STATUS == 'active' ]] ; then 
                systemctl stop firewalld
                echo -e "\e[1;31mFirewall is not actived now\e[0m"
        fi

        #Enable fireall startup with boot?
        echo -n -e "\e[1;34mEnable firewall startup with boot? yes or no: \e[0m"
        read FIREWALL_ENABLE
        if [ $FIREWALL_ENABLE == 'yes' ] ; then
                systemctl enable firewalld > /dev/null
                echo -e "\e[1;32mFirewall will be actived with boot now\e[0m"
        else
                systemctl disable firewalld > /dev/null
                echo -e "\e[1;31mFirewall will not be actived with boot now\e[0m"
        fi

        SELINUX_STATUS=`getenforce`
        if [ $SELINUX_STATUS == "Enforcing" ] ; then
                action "Selinux on: " /bin/true
        else
                action "Selinux on: " /bin/false
        fi
        echo -n -e "\e[1;34mActive Selinux? yes or no: \e[0m"
        read SELINUX

        SELINUX_CONF=/etc/selinux/config
        if [[ $SELINUX == 'yes' && $SELINUX_STATUS != "Enforcing" ]] ; then
                setenforce 1
                sed -i '/^SELINUX/c \SELINUX=enforcing' $SELINUX_CONF
                echo -e "\e[1;32mSelinux is actived now and will be actived with boot\e[0m"
        elif  [[ $SELINUX == 'no' && $SELINUX_STATUS == "Enforcing" ]] ; then
                setenforce 0
                sed -i '/^SELINUX/c \SELINUX=disabled' $SELINUX_CONF
                echo -e "\e[1;31mSelinux is not actived now and will not be actived with boot\e[0m"
        fi
}

function Grub_Lock {
        GRUB2_CONF=/boot/grub2/grub.cfg
        GRUB_CONF=/etc/grub.d/10_linux
        echo -n -e "\e[1;31mWarning: you are adding a lock to grub, yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
                return 0
        fi

        #Backup the origional configure file
        if [[ -f $GRUB_CONF.bak && -f $GRUB2_CONF.bak ]] ; then
                rm -f $GRUB_CONF
                rm -f $GRUB2_CONF
                mv $GRUB_CONF.bak $GRUB_CONF
                mv $GRUB2_CONF.bak $GRUB2_CONF
        fi
        cp $GRUB_CONF $GRUB_CONF.bak
        cp $GRUB2_CONF $GRUB2_CONF.bak

        while true; do
                echo -n -e "\e[1;34mEnter the username for grub: \e[0m"
                read GRUB_USERNAME
                echo -n -e "\e[1;34mEnter the password for grub: \e[0m"
                read GRUB_PASSWD

                echo -e "\e[1;36m*******Check the Input*******\e[0m"
                echo -e "\e[1;36m       Username=$GRUB_USERNAME\e[0m"
                echo -e "\e[1;36m       Password=$GRUB_PASSWD\e[0m"

                echo -n -e "\e[1;34mEnter yes to continue, Enter no to input again: \e[0m"
            read CHECK
                if [ $CHECK == 'yes' ] ; then
                        break;
                fi
        done

#Create encrypted password
echo "$GRUB_PASSWD
$GRUB_PASSWD
" | grub2-mkpasswd-pbkdf2 > tmpfile

        #Write the encrypted password to file
        GRUB_ENCRYPT_PASSWD=`cat tmpfile | awk -F ' ' 'NR==3 {print $7}'`
        echo 'cat <<EOF' >> $GRUB_CONF
        echo "set superusers=$GRUB_USERNAME" >> $GRUB_CONF
        echo "password_pbkdf2 $GRUB_USERNAME $GRUB_ENCRYPT_PASSWD" >> $GRUB_CONF
        echo 'EOF' >> $GRUB_CONF

        grub2-mkconfig --output=/boot/grub2/grub.cfg 
        rm -f tmpfile
}

#Call the function
#Add_User_As_Root 
#Change_SSH_Port 
Secure_Set
#Grub_Lock