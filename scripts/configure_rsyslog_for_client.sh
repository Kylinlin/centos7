#!/bin/bash
###############################################################
#File Name      :   configure_rsyslog.sh
#Arthor         :   kylin
#Created Time   :   Tue 22 Sep 2015 03:27:20 PM CST
#Email          :   kylinlingh@foxmail.com
#Github         :   https://github.com/Kylinlin
#Version        :
#Description    :
###############################################################

function Install_And_Configure {
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

Install_And_Configure
