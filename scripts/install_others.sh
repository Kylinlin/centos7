#!/bin/bash
# Author:        kylin
# E-mail:        kylinlingh@foxmail.com
# Blog:          http://www.cnblogs.com/kylinlin
# Github:        https://github.com/Kylinlin
# Date:			 2015/9/8          
# Version:      
# Function:      Install non-suit tools
################################################

function Install_Necessary_Tools {
	yum install net-tools -y > /dev/null
	yum install lrzsz -y > /dev/null	
	yum install p7zip -y > /dev/null
}

function Install_Other_Softwares { 
    echo -e "\e[1;32mInstalling command line web broswer, please wait for a while...\e[0m"
    yum install links -y > /dev/null
}

function Install_DEV_Softwares {
    echo -e "\e[1;32mInstalling develop tools and libraries, please wait for a while...\e[0m"
    yum install gcc -y > /dev/null
    yum install cmake -y > /dev/null
    yum install gcc-c++ > /dev/null
    yum install python-devel > /dev/null
    yum install java -y > /dev/null
}

function Install_Secure_Softwares { 
    echo -e "\e[1;32mInstalling NMAP, please wait for a while...\e[0m"
    yum install nmap -y > /dev/null

    echo -e "\e[1;32mInstalling Rootkit Hunter, please wait for a while...\e[0m"
    yum install rkhunter -y > /dev/null

        echo -e "\e[1;32mInstalling and downloading Malware Detect(LMD), please wait for a while...\e[0m"
	rm -rf /usr/local/mal*
	MALDETECT=maldetect-1.4.2
	cd ../packages/secure
	tar -xf maldetect-current.tar.gz > /dev/null
	cd $MALDETECT
	./install.sh > /dev/null
	MALDETECT_COND=/usr/local/maldetect/conf.maldet
	if [ -f $MALDETECT_COND.bak ] ; then
		rm -f $MALDETECT_COND
		mv $MALDETECT_COND.bak $MALDETECT_COND
	fi
	cp $MALDETECT_COND $MALDETECT_COND.bak
	sed -i '/^email_alert=0/c \email_alert=1' $MALDETECT_COND
	sed -i '/^email_subj/c \email_subj="Malware alerts for $HOSTNAME - $(date +%Y-%m-%d)"' $MALDETECT_COND
	sed -i '/^email_addr/c \email_addr=root@localhost' $MALDETECT_COND
	sed -i '/^quar_hits=0/c \quar_hits=1' $MALDETECT_COND
	sed -i '/^quar_susp=0/c \quar_susp=1' $MALDETECT_COND
	sed -i '/^clamav_scan=0/c \clamav_scan=1' $MALDETECT_COND

    echo -e "\e[1;32mInstalling and downloading Antivirus Engine(ClamAV size:90M), please wait for a while...\e[0m"
    yum install epel-release -y > /dev/null
    yum install clamav -y > /dev/null

    #Scan Maleware everyday!	
    cp -f cron.daily /etc/cron.daily/
    CRON_CONF=/var/spool/cron/root 
cat>>$CRON_CONF <<EOF
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOMT=/
SHELL=/bin/bash
EOF

}

function Install_Manage_Softwares {
    echo -n -e "\e[1;34mInstall webmin? yes or no: \e[0m"
    read WEB_MIN
    if [ $WEB_MIN == 'yes' ] ; then
	WEB_MIN_PACKAGE=webmin-1.740-1.noarch.rpm
        cd ../packages/manage
	rpm -ivh $WEB_MIN_PACKAGE > /dev/null
	firewall-cmd --add-port=10000/tcp --permanent > /dev/null
	firewall-cmd --reload > /dev/null
	echo -e "\e[1;36mNote: the username and password to login in the website is as same as root's account"
    fi
}


Install_Other_Softwares
Install_Complie_Softwares
Install_Secure_Softwares
Install_Manage_Softwares

echo -e "\e[41;33mInstall finished!!!\e[0m"
