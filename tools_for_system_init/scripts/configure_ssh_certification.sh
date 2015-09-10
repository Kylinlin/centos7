#!/bin/bash
# Author:        kylin
# E-mail:        kylinlingh@foxmail.com
# Blog:          http://www.cnblogs.com/kylinlin
# Github:        https://github.com/Kylinlin
# Date:          
# Version:      
# Function:      
################################################

function SSH_Authorization {
	USER=`whoami`
	echo -e "\e[1;31mWarning: you are configuring to login with ssh authorization instead of password! yes or no: \e[0m"
	read CHOICE
	if [ $CHOICE == 'no' ] ; then
		return 0
	fi

	echo -e "\e[1;31mYou must switch to your own username instead of root!!\e[0m"

	SSH_CONF=/etc/ssh/sshd_config
	if [ -f $SSH_CONF.bakk ]; then
		rm -f $SSH_CONF
		mv $SSH_CONF.bakk $SSH_CONF
	fi
	cp $SSH_CONF $SSH_CONF.bakk
	sed -i "/^#StrictModes yes/c \StrictModes no $PORT_NUM" $SSH_CONF
	sed -i "/^#RSAAuthentication yes/c \RSAAuthentication yes" $SSH_CONF
	sed -i "/^#PubkeyAuthentication yes/c \PubkeyAuthentication yes" $SSH_CONF
	sed -i "/^AuthorizedKeysFile/c \AuthorizedKeysFile      ~/.ssh/authorized_keys" $SSH_CONF
	sed -i "/^#PasswordAuthentication yes/c \PasswordAuthentication no" $SSH_CONF

	echo -e "\e[1;34mCopy your client's certification to /home/$USER! yes or no: \e[0m"
	read CHOICE
	if [ $CHOICE == 'no' ] ; then
		return 0
	fi
	while [ ! -f /home/$USER/id_rsa.pub ]; then
		echo -e "\e[1;31mThere is not id_rsa.pub file in /home/$USER !\e[0m"
	done

	cd /home/$USER
	cat id_rsa.pub >> ~/.ssh/authorized_keys
	
	sudo systemctl restart sshd.service		
}
