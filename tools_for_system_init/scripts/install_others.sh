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

Install_Other_Tools