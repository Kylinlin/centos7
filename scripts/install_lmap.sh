#!/bin/bash
# Author:        kylin
# E-mail:        kylinlingh@foxmail.com
# Blog:          http://www.cnblogs.com/kylinlin
# Github:        https://github.com/Kylinlin
# Date:          2015/9/8 
# Version:       1.0
# Function:      Install LMAP
################################################

. /etc/rc.d/init.d/functions

CONFIGURED_OPTIONS=../log/configured_options.log
UNCONFIGURED_OPTIONS=../log/unconfigured_options.log

function Install_APACHE_HTTP {
	echo -e "\e[1;33mInstalling Apache, please wait for a while...\e[0m"
	yum remove httpd -y > /dev/null
	yum install httpd -y > /dev/null
	
	echo -n -e "\e[1;34mDo you want to change the 80 port? yes or no: \e[0m"
	read CON_HTTP_PORT
	if [ $CON_HTTP_PORT == 'yes' ]; then 
		echo -n -e "\e[1;34mEnter the port number: \e[0m"
		read NEW_HTTP_PORT

		HTTP_CONF=/etc/httpd/conf/httpd.conf
		cp $HTTP_CONF $HTTP_CONF.bak

		#Configure new port for httpd
		sed -i "/^Listen/c \Listen $NEW_HTTP_PORT" $HTTP_CONF

		#Configure firewall to enable the new port
		firewall-cmd --add-service=http > /dev/null
		firewall-cmd --permanent --add-port=$NEW_HTTP_PORT/tcp > /dev/null
		firewall-cmd --reload > /dev/null
		systemctl restart httpd.service > /dev/null
		
		echo -e "\e[1;32m+Installed apache and changed port to: $NEW_HTTP_PORT\e[0m" >> $CONFIGURED_OPTIONS
	fi

	#Configure startup httpd with system boot.
	systemctl restart httpd.service > /dev/null 
	systemctl enable httpd.service > /dev/null

	#Check the service
	if [ `systemctl status httpd | awk -F ' ' 'NR==3 {print $2}'` == 'active' ] ; then
		action "Http service on: " /bin/true
	else
		action "Http service on: " /bin/false
	fi
	echo -e "\e[1;32m+Installed apache \e[0m" >> $CONFIGURED_OPTIONS
}

function Install_PHP {
	echo -e "\e[1;33mInstalling PHP, please wait for a while...\e[0m"
	yum remove php -y > /dev/null
	yum install php -y > /dev/null																																							    
	systemctl restart httpd.service > /dev/null
	echo -e "\e[1;32m+Installed php \e[0m" >> $CONFIGURED_OPTIONS

	#Check PHP
	#echo -e "<?php\nphpinfo();\n?>" > /var/www/html/phpinfo.php
	#links http://127.0.0.1/phpinfo.php
}

function Install_MYSQL {
	echo -e "\e[1;32mInstalling PHP, please wait for a while...\e[0m"
	yum install wget -y > /dev/null
	cd ../packages
	DIRECORY=`pwd`
	wget -qO- https://raw.github.com/Kylinlin/mysql/master/setup.sh | sh -x
	cp $DIRECORY/mysql/log/install_mysql.log $DIRECORY/../log/
	echo -e "\e[1;32m+Installed mysql \e[0m" >> $CONFIGURED_OPTIONS
}

Install_APACHE_HTTP
Install_PHP
Install_MYSQL
echo -e "\e[1;36mInstall LMAP finished!\e[0m"
