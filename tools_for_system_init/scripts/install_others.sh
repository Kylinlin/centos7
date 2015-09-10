#!/bin/bash
# Author:        kylin
# E-mail:        kylinlingh@foxmail.com
# Blog:          http://www.cnblogs.com/kylinlin
# Github:        https://github.com/Kylinlin
# Date:                  2015/9/8          
# Version:      
# Function:      Install non-suit tools
################################################

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
    echo -n -e "\e[1;34mInstall webmin? yes or no: \e[0m"
    read WEB_MIN
    if [ $WEB_MIN == 'yes' ] ; then
                WEB_MIN_PACKAGE=webmin-1.740-1.noarch.rpm
        cd ../packages
                rpm -ivh $WEB_MIN_PACKAGE > /dev/null
                firewall-cmd --add-port=10000/tcp --permanent > /dev/null
                firewall-cmd --reload > /dev/null
                echo -e "\e[1;36mNote: the username and password to login in the website is as same as root's account"
    fi
}


Install_Other_Tools
Install_Complie_Tools
Install_Secure_Tools
Install_Manage_Tools

echo -e "\e[41;33mInstall finished!!!\e[0m"