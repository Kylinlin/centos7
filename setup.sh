#!/bin/bash
###############################################################
#File Name      :   setup.sh
#Arthor         :   kylin
#Created Time   :   Sat 19 Sep 2015 04:04:15 AM CST
#Email          :   kylinlingh@foxmail.com
#Github         :   https://github.com/Kylinlin
#Version        :   1.0
#Description    :   Install mysql through network.
###############################################################
 
 
function Setup {
    yum install git dos2unix -y > /dev/null
    git clone https://github.com/Kylinlin/centos7.git
    cd centos7/scripts/
	dos2unix *
	
	DIRECTORY=`pwd`
	echo "export GLOBAL_DIRECTORY=$DIRECTORY" > ~/global_directory.txt
	
	#sh configure_network.sh
	#sh configure_hostname.sh
	#sh configure_system.sh
	#sh configure_ssh_certification.sh
	
	#sh install_lamp.sh
	#sh install_other.sh	
}
 
Setup
