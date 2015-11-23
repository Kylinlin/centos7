#!/bin/bash
###############################################################
#File Name      :   startup.sh
#Arthor         :   kylin
#Created Time   :   Wed 08 Sep 2015 11:03:52 AM CST
#Email          :   kylinlingh@foxmail.com
#Blog           :   http://www.cnblogs.com/kylinlin/
#Github         :   https://github.com/Kylinlin
#Version        :	1.0
#Description    :	To install non-suits 's software.
###############################################################

source ~/global_directory.txt

CONFIGURED_OPTIONS=$GLOBAL_DIRECTORY/../log/configured_options.log
UNCONFIGURED_OPTIONS=$GLOBAL_DIRECTORY/../log/unconfigured_options.log

function Install_Necessary_Tools {
	echo -e "\e[1;33mInstalling necessary tools, please wait for a while...\e[0m"
	yum install net-tools -y > /dev/null
	yum install lrzsz -y > /dev/null	
	yum install p7zip -y > /dev/null
}

function Install_Other_Softwares { 
    #echo -e "\e[1;32mInstalling command line web broswer, please wait for a while...\e[0m"
    #yum install links -y > /dev/null
    echo -e "\e[1;35mInstall nagios, yes or no: \e[0m"
    read CHOICE
    if [[ $CHOICE == 'yes' ]]; then
        echo -e "\e[1;35mEnter 1 for nagios_server, 2 for nagios_client: \e[0m"
        read NAGIOS
        if [[ $NAGIOS == 1 ]]; then
            cd $GLOBAL_DIRECTORY/../packages
            wget -qO- https://raw.github.com/Kylinlin/nagios/master/setup_for_server.sh | sh -x
            echo -e "\e[1;32m+Installed nagios_for_server \e[0m" >> $CONFIGURED_OPTIONS
        elif [[ $NAGIOS == 2 ]]; then
            cd $GLOBAL_DIRECTORY/../packages
            wget -qO- https://raw.github.com/Kylinlin/nagios/master/setup_for_client.sh | sh -x
            echo -e "\e[1;32m+Installed nagios_for_client \e[0m" >> $CONFIGURED_OPTIONS
        else
            echo "\e[1;36mWrong input. It will not install nagios. \e[0m"
        fi
    fi
    
}

function Install_DEV_Softwares {
    echo -e "\e[1;33mInstalling develop tools and libraries, please wait for a while...\e[0m"
    yum install gcc -y > /dev/null
    yum install cmake -y > /dev/null
    yum install gcc-c++ -y > /dev/null
    yum install python-devel -y > /dev/null
    yum install java -y > /dev/null
}

function Install_Secure_Softwares { 
    echo -e "\e[1;33mInstalling NMAP, please wait for a while...\e[0m"
    yum install nmap -y > /dev/null
	echo -e "\e[1;32m+Installed Nmap\e[0m" >> $CONFIGURED_OPTIONS

    echo -e "\e[1;33mInstalling Rootkit Hunter, please wait for a while...\e[0m"
    yum install rkhunter -y > /dev/null
	
	echo -e "\e[1;32m+Installed Rkhunter\e[0m" >> $CONFIGURED_OPTIONS

    echo -e "\e[1;33mInstalling and downloading Malware Detect(LMD), please wait for a while...\e[0m"
	rm -rf /usr/local/mal*
	
	MALDETECT=maldetect-1.4.2
	cd $GLOBAL_DIRECTORY/../packages/secure
	tar -xf maldetect-current.tar.gz > /dev/null
	cd $MALDETECT
	./install.sh > /dev/null
	MALDETECT_COND=/usr/local/maldetect/conf.maldet
	if [ -f $MALDETECT_COND.bak ] ; then
		rm -f $MALDETECT_COND
		mv $MALDETECT_COND.bak $MALDETECT_COND
	fi
	cp $MALDETECT_COND $MALDETECT_COND.bak
	echo -n -e "\e[1;35mEnter the email address which you want to reveive the report: \e[0m"
	read EMAIL
	sed -i '/^email_alert=0/c \email_alert=1' $MALDETECT_COND
	sed -i '/^email_subj/c \email_subj="Malware alerts for $HOSTNAME - $(date +%Y-%m-%d)"' $MALDETECT_COND
	sed -i "/^email_addr/c \email_addr=$EMAIL" $MALDETECT_COND
	sed -i '/^quar_hits=0/c \quar_hits=1' $MALDETECT_COND
	sed -i '/^quar_susp=0/c \quar_susp=1' $MALDETECT_COND
	sed -i '/^clamav_scan=0/c \clamav_scan=1' $MALDETECT_COND

    #Install Clamav
    echo -e "\e[1;33mInstalling and downloading Antivirus Engine(ClamAV size:90M), please wait for a while...\e[0m"
    yum install epel-release -y > /dev/null
#   yum install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd -y > /dev/null
    yum install yum install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd -y > /dev/null
    sed -i -e “s/^Example/#Example/” /etc/freshclam.conf
    sed -i -e “s/^Example/#Example/” /etc/clamd.d/scan.conf
    freshclam
    sed -i '24d' /etc/sysconfig/freshclam 
    sed -i '6c* 02 * * * root /usr/share/clamav/freshclam-sleep' /etc/cron.d/clamav-update 
    echo "MAILTO=root" > /etc/cron.d/clamav-scan-daily
    echo "* 03 * * * root clamscan -r --bell -i / " >> /etc/cron.d/clamav-scan-daily
    sed -i "/^#LocalSocket /var/run/clamd.scan/clamd.sock/c \LocalSocket /var/run/clamd.scan/clamd.sock" /etc/clam.d/scan.conf
    systemctl enable clamd@scan
    systemctl  start clamd@scan

	echo -e "\e[1;32m+Installed LMD and ClamAV\e[0m" >> $CONFIGURED_OPTIONS

    #Install nethogs to monitor the network
    yum install libpcap libpcap-devel > /dev/null
    cd $GLOBAL_DIRECTORY/../packages
    NETHOGS=nethogs-0.8.0
    tar -xf $NETHOGS.tar.gz 
    cd nethogs
    make && make install > /dev/null
    echo -e "\e[1;32m+Installed Nethogs to monitor network\e[0m" >> $CONFIGURED_OPTIONS

    #Install nload to monitor the network
    yum install nload -y > /dev/null
    echo -e "\e[1;32m+Installed Nload to monitor network\e[0m" >> $CONFIGURED_OPTIONS

    #Install setroubleshoot
    yum install setroubleshoot setools -y > /dev/null
    echo "MAILTO=root" > /etc/cron.d/setroubleshoot
    echo "* 03 * * * root sealert -a /var/log/audit/audit.log " >> /etc/cron.d/setroubleshoot
    echo -e "\e[1;32m+Installed setroubleshoot\e[0m" >> $CONFIGURED_OPTIONS

    #Install portsentry
    cd $GLOBAL_DIRECTORY/../packages
    PORTSENTRY=portsentry-1.2
    tar -xf $PORTSENTRY.tar.gz 
    cd portsentry_beta

    cp portsentry.c portsentry.c.bak
    sed -i '1584,1585d' portsentry.c 
    sed -i '1583a printf ("Copyright 1997-2003 Craig H. Rowland <craigrowland at users dot sourceforget dot net>\\n");' portsentry.c

    make linux > /dev/null
    make install > /dev/null

echo > /etc/init.d/portsentry <<EOF
#!/bin/bash

case "$1" in
start)
echo "Starting Portsentry..."
ps ax | grep -iw '/usr/local/psionic/portsentry/portsentry -atcp' | grep -iv 'grep' > /dev/null
if [ $? != 0 ]; then
/usr/local/psionic/portsentry/portsentry -atcp
fi
ps ax | grep -iw '/usr/local/psionic/portsentry/portsentry -audp' | grep -iv 'grep' > /dev/null
if [ $? != 0 ]; then
/usr/local/psionic/portsentry/portsentry -audp
fi
echo "Portsentry is now up and running!"
;;
stop)
echo "Shutting down Portsentry..."
array=(`ps ax | grep -iw '/usr/local/psionic/portsentry/portsentry' | grep -iv 'grep' \
| awk '{print $1}' | cut -f1 -d/ | tr '\n' ' '`)
element_count=${#array[@]}
index=0
while [ "$index" -lt "$element_count" ]
do
kill -9 ${array[$index]}
let "index = $index + 1"
done
echo "Portsentry stopped!"
;;
restart)
$0 stop && sleep 3
$0 start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0
EOF
    chmod +x /etc/init.d/portsentry

    chmod 755 /etc/init.d/portsentry
    ln -s /etc/init.d/portsentry /etc/rc2.d/S20portsentry
    ln -s /etc/init.d/portsentry /etc/rc3.d/S20portsentry
    ln -s /etc/init.d/portsentry /etc/rc4.d/S20portsentry
    ln -s /etc/init.d/portsentry /etc/rc5.d/S20portsentry
    ln -s /etc/init.d/portsentry /etc/rc0.d/K20portsentry
    ln -s /etc/init.d/portsentry /etc/rc1.d/K20portsentry
    ln -s /etc/init.d/portsentry /etc/rc6.d/K20portsentry

    echo -e "\e[1;35mEnter the remote ip address you want to allow to scan the ports for this machine: \e[0m" >> $CONFIGURED_OPTIONS
    read REMOTE_IP
    if [[ $REMOTE_IP != '' ]]; then
        echo $REMOTE_IP >> /usr/local/psionic/portsentry/portsentry.ignore
    fi

    /etc/init.d/portsentry start

    echo -e "\e[1;32m+Installed portsentry. And the allowed ip is: $REMOTE_IP\e[0m" >> $CONFIGURED_OPTIONS
}



Install_Other_Softwares
Install_Necessary_Tools
Install_DEV_Softwares
Install_Secure_Softwares


echo -e "\e[1;32mInstall finished!!!\e[0m"
