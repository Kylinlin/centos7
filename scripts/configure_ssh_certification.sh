#!/bin/bash
# Author:        kylin
# E-mail:        kylinlingh@foxmail.com
# Blog:          http://www.cnblogs.com/kylinlin
# Github:        https://github.com/Kylinlin
# Date:          2015/9/9 
# Version:       1.0
# Function:      
################################################

function Echo_Information {
    echo "+------------------------SSH_Certification Informations(SSH证书登陆配置信息)---------------------------+
    English Description:
        
        1.Disable logins as root.
        2.Disable logins using password.
        3.Must set password for your private key.

    中文描述：
        
        1.禁止了以root身份登陆
        2.禁止了使用密码登陆
        3.必须给你的私钥加上密码
+------------------------------------------------------------------------------------------------------+" >> ../logs/install.log 
}

function SSH_Authorization {
        echo -n -e "\e[1;31mWarning: you are configuring to login with ssh authorization instead of password! yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
                return 0
        fi

    while true; do
        echo -n -e "\e[1;36mEnter the username you want to configure: "
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
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
                return 0
        fi
        done

        SSH_CONF=/etc/ssh/sshd_config
        if [ -f $SSH_CONF.bakk ]; then
                rm -f $SSH_CONF
                mv $SSH_CONF.bakk $SSH_CONF
        fi
        cp $SSH_CONF $SSH_CONF.bakk
        sed -i "/^#PermitRootLogin yes/c \PermitRootLogin no" $SSH_CONF
        sed -i "/^#StrictModes yes/c \StrictModes no" $SSH_CONF
        sed -i "/^#RSAAuthentication yes/c \RSAAuthentication yes" $SSH_CONF
        sed -i "/^#PubkeyAuthentication yes/c \PubkeyAuthentication yes" $SSH_CONF
        sed -i "/^AuthorizedKeysFile/c \AuthorizedKeysFile      .ssh/authorized_keys" $SSH_CONF
        sed -i "/^#PasswordAuthentication yes/c \PasswordAuthentication no" $SSH_CONF


    if [[ ! -d /home/$USER_NAME/.ssh ]]; then
        mkdir /home/$USER_NAME/.ssh
        chown -R $USER_NAME:$USER_NAME  /home/$USER_NAME/.ssh/
        chmod 700  /home/$USER_NAME/.ssh
    fi
    
    cat /home/$USER_NAME/id_rsa.pub >> /home/$USER_NAME/.ssh/authorized_keys
    chmod 644  /home/$USER_NAME/.ssh/authorized_keys
    chown -R $USER_NAME:$USER_NAME  /home/$USER_NAME/.ssh/authorized_keys

    sudo systemctl restart sshd.service
    echo -e "\e[1;32mSSH_Certification configure finished.\e[0m"
}

#Call the functions
Echo_Information
SSH_Authorization
