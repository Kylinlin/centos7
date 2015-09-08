#!/bin/bash
#Author:        kylin
#E-mail:        kylinlingh@foxmail.com
#blog:          http://www.cnblogs.com/kylinlin
#github:        https://github.com/Kylinlin
#Date:          2015/9/8
#version:       1.0
#Function:      Install useful software
################################################

. /etc/rc.d/init.d/functions

function Install_Other_Tools {
    echo -e "\e[1;32mInstalling Net-tools, please wait for a while...\e[0m"
    yum install net-tools -y >> /dev/null
    echo -e "\e[1;32mInstalling command line web broswer, please wait for a while...\e[0m"
    yum install links -y >> /dev/null
}

function Install_Complie_Tools {
    echo -e "\e[1;32mInstalling GCC, please wait for a while...\e[0m"
    yum install gcc -y >> /dev/null
    echo -e "\e[1;32mInstalling JAVA, please wait for a while...\e[0m"
    yum install java -y >> /dev/null
}

function Install_Secure_Tools { 
    echo -e "\e[1;32mInstalling NMAP, please wait for a while...\e[0m"
    yum install nmap -y >> /dev/null
}

function Install_Manage_Tools {
    echo -e "\e[1;32, please wait for a while...\e[0m"
     
}


Install_Other_Tools
Install_Complie_Tools
Install_Secure_Tools
#Install_Manage_Tools

#echo -e "\e[41;33mInstall finished!!!\e[0m"