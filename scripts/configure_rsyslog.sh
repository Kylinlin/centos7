#!/bin/bash
###############################################################
#File Name      :   configure_rsyslog_for_server.sh
#Arthor         :   kylin
#Created Time   :   Tue 22 Sep 2015 03:47:57 PM CST
#Update Time    :   Fri Nov 20 22:49:39 CST 2015
#Email          :   kylinlingh@foxmail.com
#Github         :   https://github.com/Kylinlin
#Version        :   2.0
#Description    :   配置Rsyslog系统
###############################################################

function Install_And_Configure_For_Server {
    echo -e "\e[1;33mInstalling and configuring rsyslog for remote server,please wait for a while...\e[0m"
    rpm -qa | grep rsyslog > /dev/null
    if [[ $? == 1 ]]; then
        yum install rsyslog -y > /dev/null
    fi

    RLOG_CONF=/etc/rsyslog.conf
    if [[ -f $RLOG_CONF.bak ]]; then
        rm -f $RLOG_CONF
        mv $RLOG_CONF.bak $RLOG_CONF
    else
        cp $RLOG_CONF $RLOG_CONF.bak
    fi

    sed -i '/^#$ModLoad imklog/c \$ModLoad imklog' $RLOG_CONF
    sed -i '/^#$ModLoad immark /c \$ModLoad immark' $RLOG_CONF
    sed -i '/^#$ModLoad imudp/c \$ModLoad imudp' $RLOG_CONF
    sed -i '/^#$UDPServerRun 514/c \$UDPServerRun 514' $RLOG_CONF
    sed -i '/^#$ModLoad imtcp/c \$ModLoad imtcp' $RLOG_CONF
    sed -i '/^#$InputTCPServerRun 514/c \$InputTCPServerRun 514' $RLOG_CONF

    sed -i '22i $template RemoteLogs,"/var/log/%HOSTNAME%/%PROGRAMNAME%.log" *' $RLOG_CONF
    sed -i '23i *.* ?RemoteLogs' $RLOG_CONF
    sed -i '24i & ~' $RLOG_CONF

    systemctl restart rsyslog
	systemctl enable rsyslog.service > /dev/null
    echo -e "\e[1;32mInstall and configure server finished.\e[0m"
}

function Install_And_Configure_For_Client {
    echo -e "\e[1;33mInstalling and configuring rsyslog, please wait for a while...\e[0m"
    rpm -qa | grep rsyslog > /dev/null
    if [[ $? == 1 ]]; then
        yum install rsyslog -y > /dev/null
    fi

    #Configure rsyslog to send logs
    RLOG_CONF=/etc/rsyslog.conf
    if [[ -f $RLOG_CONF.bak ]]; then
        rm -f RLOG_CONF
        mv $RLOG_CONF.bak $RLOG_CONF
    else
        cp $RLOG_CONF $RLOG_CONF.bak
    fi
    echo -n -e "\e[1;35mEnter the remote server's ip: \e[0m"
    read IP
    echo "*.* @$IP:514" >> $RLOG_CONF

    #Configure the remote server to record all command.
    
    BASH_CONF=/etc/bashrc
    if [[ -f $BASH_CONF.bak ]]; then
        rm -f $BASH_CONF
        mv $BASH_CONF.bak $BASH_CONF
    else
        cp $BASH_CONF $BASH_CONF.bak
    fi
    cat >> $BASH_CONF<<EOF
export PROMPT_COMMAND='{ msg=\$(history 1 | { read x y; echo \$y; });logger "[euid=\$(whoami)]":\$(who am i):[\`pwd\`]"\$msg"; }'
EOF
    source /etc/bashrc
    source /etc/bashrc

    systemctl restart rsyslog > /dev/null
	systemctl enable rsyslog.service > /dev/null
	echo -e "\e[1;32m+Configure remote log system \e[0m"
}

function Startup {
    while true; do
        echo -n -e "\e[1;35mEnter 1 to configure server, enter 2 to configure client, enter n to cancel: \e[0m"
        read CHOICE
        if [[ $CHOICE == 1 ]]; then
            Install_And_Configure_For_Server
        elif [[ $CHOICE == 2 ]]; then
            Install_And_Configure_For_Client
        elif [[ $CHOICE == 'n' ]]; then
            return 0
        else
            echo -n -e "\e[1;31mYou have entered the wrong character, try again?[y/n]: \e[0m"
            read AGAIN
            if [[ $AGAIN == 'n' ]]; then
                return 0
            fi
        fi
    done
}

Startup
