#!/bin/bash
###############################################################
#File Name      :   startup.sh
#Arthor         :   kylin
#Created Time   :   Wed 23 Sep 2015 11:03:52 AM CST
#Email          :   kylinlingh@foxmail.com
#Blog           :   http://www.cnblogs.com/kylinlin/
#Github         :   https://github.com/Kylinlin
#Version        :	1.0
#Description    :	To initialize system.
###############################################################

function Startup {
    echo -e "\e[1;33mBegin to initialize system.\e[0m" 
    echo -e "\e[42;35m\e[5mRunning this script: configure_system.sh\e[0m" 
    sh configure_system.sh
    echo -e "\e[42;35m\e[5mRunning this script: install_lmap.sh\e[0m" 
    sh install_lmap.sh
    echo -e "\e[42;35m\e[5mRunning this script: install_others.sh\e[0m" 
    sh install_others.sh
    
    echo -n -e "\e[1;35mEnter 1 for rsyslog server, 2 for rsyslog client: \e[0m "
    read RSYSLOG
    if [[ $RSYSLOG == 1 ]]; then
        echo -e "\e[42;35m\e[5mRunning this script: configure_rsyslog_for_server.sh\e[0m" 
        sh configure_rsyslog_for_server.sh
    elif [[ $RSYSLOG == 2 ]]; then
        echo -e "\e[42;35m\e[5mRunning this script: configure_rsyslog_for_client.sh\e[0m" 
        sh configure_rsyslog_for_client.sh
    else
        echo -e "\e[1;31mWrong input. \e[0m"
    fi
    echo -e "\e[42;35m\e[5mConfiguration, you have get it all done.\e[0m" 
}

Startup
