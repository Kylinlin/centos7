#!/bin/bash
###############################################################
#File Name      :   configure_rsyslog_for_server.sh
#Arthor         :   kylin
#Created Time   :   Tue 22 Sep 2015 03:47:57 PM CST
#Email          :   kylinlingh@foxmail.com
#Github         :   https://github.com/Kylinlin
#Version        :
#Description    :
###############################################################

function Install_And_Configure {
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

Install_And_Configure
