#!/bin/bash
###############################################################
#File Name      :   startup.sh
#Arthor         :   kylin
#Created Time   :   Wed 08 Sep 2015 11:03:52 AM CST
#Email          :   kylinlingh@foxmail.com
#Blog           :   http://www.cnblogs.com/kylinlin/
#Github         :   https://github.com/Kylinlin
#Version        :	1.0
#Description    :	To install lmap.
###############################################################

. /etc/rc.d/init.d/functions

source ~/global_directory.txt

CONFIGURED_OPTIONS=$GLOBAL_DIRECTORY/../log/configured_options.log
UNCONFIGURED_OPTIONS=$GLOBAL_DIRECTORY/../log/unconfigured_options.log

function Install_APACHE_HTTP {
	echo -e "\e[1;33mInstalling Apache, please wait for a while...\e[0m"
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
	else
		echo -e "\e[1;32m+Installed apache \e[0m" >> $CONFIGURED_OPTIONS
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
}

function Install_PHP {
	echo -e "\e[1;33mInstalling PHP, please wait for a while...\e[0m"
	yum install php -y > /dev/null																																							    
	systemctl restart httpd.service > /dev/null
	echo -e "\e[1;32m+Installed php \e[0m" >> $CONFIGURED_OPTIONS

	#Check PHP
	#echo -e "<?php\nphpinfo();\n?>" > /var/www/html/phpinfo.php
	#links http://127.0.0.1/phpinfo.php
}

function Install_MYSQL {
	echo -e "\e[1;33mInstalling MYSQL5.6, please wait for a while...\e[0m"

	cd $GLOBAL_DIRECTORY/../packages
	wget -qO- https://raw.github.com/Kylinlin/mysql/master/setup.sh | sh 
	cp $GLOBAL_DIRECTORY/../packages/mysql/log/install_mysql.log $GLOBAL_DIRECTORY/../log/
	echo -e "\e[1;32m+Installed mysql \e[0m" >> $CONFIGURED_OPTIONS
}

Install_APACHE_HTTP
Install_PHP
Install_MYSQL
echo -e "\e[1;32mInstall LMAP finished!\e[0m"
