#!/bin/bash
###############################################################
#File Name      :   fw.sh
#Arthor         :   kylin
#Created Time   :   Wed Sep 16 17:47:09 CST 2015 
#Email          :   kylinlingh@foxmail.com
#Blog           :   http://www.cnblogs.com/kylinlin/
#Github         :   https://github.com/Kylinlin
#Version        :
#Description    :
###############################################################

. /etc/rc.d/init.d/functions

function Add_User_As_Root {
        echo -n -e "\e[1;35mWarning: you are adding a user as root's privilege! yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
			#echo -e "\e[1;35m-Add user as root's privelege\e[0m" >> $UNCONFIGURED_OPTIONS
                return 0
        fi

        while true; do
            echo -n -e "\e[1;34mEnter the username: \e[0m" 
            read USER_NAME
            echo -n -e "\e[1;34mEnter the passwd: \e[0m"
            read PASSWD

            echo -e "\e[1;36m*******Check the Input*******\e[0m"
			echo -e "\e[1;36m       Username=$USER_NAME\e[0m"
			echo -e "\e[1;36m       Password=$PASSWD\e[0m"
			echo -n -e "\e[1;34mEnter yes to continue, Enter no to input again: \e[0m"
			read CHECK
			if [ $CHECK == 'yes' ] ; then
				break;
			fi
        done

        useradd $USER_NAME
echo "$PASSWD
$PASSWD
" | passwd $USER_NAME > /dev/null
        gpasswd -a $USER_NAME wheel
        echo -e "\e[1;32mUser $USER_NAME has been added sucessfully! Every command must come after \"sudo\" \e[0m"
		#echo -e "\e[1;32m+Add user: $USER_NAME; password:$PASSWD \e[0m" >> $CONFIGURED_OPTIONS
        echo -e "\e[1;32mNote: Maybe you need to restrict $USER_NAME's privilege, reference my manual. \e[0m"
}


function SSH_Authorization {
        echo -n -e "\e[1;35mWarning: you are configuring to login with ssh authorization instead of password! yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
			#echo -e "\e[1;35m-Configure SSH_Authorization\e[0m" >> $UNCONFIGURED_OPTIONS
            return 0
        fi

    while true; do
        echo -n -e "\e[1;34mEnter the username you want to configure: \e[0m"
        read USER_NAME
        id $USER_NAME > /dev/null
        if [[ $? == 1 ]] ; then
            echo -e "\e[1;31mThere is no user: $USER_NAME. Please add this user or re enter another username.\e[0m"
        else
            break
        fi
    done

        while [ ! -f /home/$USER_NAME/id_rsa.pub ]; do
            echo -e "\e[1;31mThere is not id_rsa.pub file in /home/$USER_NAME !\e[0m"
            echo -n -e "\e[1;34mCopy your client's certification to /home/$USER_NAME! yes or no: \e[0m"
			read COPY
			if [ $COPY == 'no' ] ; then
                return 0
			fi
        done

        # SSH_CONF=/etc/ssh/sshd_config
        # if [ -f $SSH_CONF.bakk ]; then
                # rm -f $SSH_CONF
                # mv $SSH_CONF.bakk $SSH_CONF
        # fi
        # cp $SSH_CONF $SSH_CONF.bakk
        # sed -i "/^#PermitRootLogin yes/c \PermitRootLogin no" $SSH_CONF
        # sed -i "/^#StrictModes yes/c \StrictModes no" $SSH_CONF
        # sed -i "/^#RSAAuthentication yes/c \RSAAuthentication yes" $SSH_CONF
        # sed -i "/^#PubkeyAuthentication yes/c \PubkeyAuthentication yes" $SSH_CONF
        # sed -i "/^AuthorizedKeysFile/c \AuthorizedKeysFile      .ssh/authorized_keys" $SSH_CONF
        # sed -i "/^#PasswordAuthentication yes/c \PasswordAuthentication no" $SSH_CONF


    if [[ ! -d /home/$USER_NAME/.ssh ]]; then
        mkdir /home/$USER_NAME/.ssh
        chown -R $USER_NAME:$USER_NAME  /home/$USER_NAME/.ssh/
        chmod 700  /home/$USER_NAME/.ssh
    fi
    
    cat /home/$USER_NAME/id_rsa.pub >> /home/$USER_NAME/.ssh/authorized_keys
    chmod 644  /home/$USER_NAME/.ssh/authorized_keys
    chown -R $USER_NAME:$USER_NAME  /home/$USER_NAME/.ssh/authorized_keys

    sudo systemctl restart sshd.service
	
	echo -e -n "\e[1;35mEnter the password for your certification: \e[0m"
	read PASSWORD_SSH
    echo -e "\e[1;32mSSH_Certification configure finished.\e[0m"
	#echo -e "\e[1;32m+Configure SSH_Authorization, username:$USER_NAME, password:$PASSWORD_SSH\e[0m" >> $CONFIGURED_OPTIONS
}

Add_User_As_Root
SSH_Authorization

