#!/bin/bash
###############################################################
#File Name      :   fw.sh
#Arthor         :   kylin
#Created Time   :   Wed Sep 16 17:47:09 CST 2015 
#Email          :   kylinlingh@foxmail.com
#Blog           :   http://www.cnblogs.com/kylinlin/
#Github         :   https://github.com/Kylinlin
#Version        :
#Description    :
###############################################################

. /etc/rc.d/init.d/functions
source ~/global_directory.txt

CONFIGURED_OPTIONS=$GLOBAL_DIRECTORY/../log/configured_options.log
UNCONFIGURED_OPTIONS=$GLOBAL_DIRECTORY/../log/unconfigured_options.log

function Update_System {
        echo -n -e "\e[1;35mWarning: you are updating the system! yes or no: \e[0m"
        read UPDATE_SYSTEM 
        if [ $UPDATE_SYSTEM == 'yes' ] ; then
            echo -e "\e[1;33mUpadting and upgrading system, please wait for a while...\e[0m"
            yum -y update > /dev/null
			yum -y upgrade > /dev/null
            echo -e "\e[1;32mUpadte system has been done.\e[0m"
			echo -e "\e[1;32m+Upadte system.\e[0m" >> $CONFIGURED_OPTIONS
        else
			echo -e "\e[1;35m-Upadte system.\e[0m" >> $UNCONFIGURED_OPTIONS
		fi

        #Update system everyday
        echo "00 1 * * * root /usr/bin/yum update -y" >> /etc/crontab 

        #Add extra package for enterprise linux repository and community enterprise linux repository
        echo -n -e "\e[1;35mWarning: you are adding the third repository for the system! yes or no: \e[0m"
        read THIRD_REPOSITORY
        if [ $THIRD_REPOSITORY == 'yes' ] ; then
            echo -e "\e[1;33mAdding the third repository to the  system, please wait for a while...\e[0m"
            yum install epel-release -y > /dev/null
            rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm > /dev/null
            echo -e "\e[1;32mAdding the third repository to the system has been done.\e[0m"
			echo -e "\e[1;32m+Add third repository.\e[0m" >> $CONFIGURED_OPTIONS
		else
			echo -e "\e[1;35m-Add third repository.\e[0m" >> $UNCONFIGURED_OPTIONS
        fi
}

function Add_User_As_Root {
        echo -n -e "\e[1;35mWarning: you are adding a user as root's privilege! yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
			echo -e "\e[1;35m-Add user as root's privelege\e[0m" >> $UNCONFIGURED_OPTIONS
                return 0
        fi

        while true; do
            echo -n -e "\e[1;34mEnter the username: \e[0m" 
            read USER_NAME
            echo -n -e "\e[1;34mEnter the passwd: \e[0m"
            read PASSWD

            echo -e "\e[1;36m*******Check the Input*******\e[0m"
			echo -e "\e[1;36m       Username=$USER_NAME\e[0m"
			echo -e "\e[1;36m       Password=$PASSWD\e[0m"
			echo -n -e "\e[1;34mEnter yes to continue, Enter no to input again: \e[0m"
			read CHECK
			if [ $CHECK == 'yes' ] ; then
				break;
			fi
        done

        useradd $USER_NAME
echo "$PASSWD
$PASSWD
" | passwd $USER_NAME > /dev/null
        gpasswd -a $USER_NAME wheel
        echo -e "\e[1;32mUser $USER_NAME has been added sucessfully! Every command must come after \"sudo\" \e[0m"
		echo -e "\e[1;32m+Add user: $USER_NAME; password:$PASSWD \e[0m" >> $CONFIGURED_OPTIONS
        echo -e "\e[1;32mNote: Maybe you need to restrict $USER_NAME's privilege, reference my manual. \e[0m"
}

function Change_SSH_Port {
        echo -n -e "\e[1;35mWarning: you are changing the port of ssh! yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
			echo -e "\e[1;35m-Change ssh port\e[0m" >> $UNCONFIGURED_OPTIONS
                return 0
        fi

        SSH_CONF=/etc/ssh/sshd_config
        if [ -f $SSH_CONF.bak ]; then
                rm -f $SSH_CONF
                mv $SSH_CONF.bak $SSH_CONF
        fi
        cp $SSH_CONF $SSH_CONF.bak
        echo -n -e "\e[1;34mEnter the port number for SSH(between 1025 to 65536): \e[0m"
        read PORT_NUM
        echo -e "\e[1;33mPlease wait for a while...\e[0m"
        sed -i "/^#Port /c \Port $PORT_NUM" $SSH_CONF
        sed -i "/^Port /c \Port $PORT_NUM" $SSH_CONF
        sed -i "/^#Protocol 2/c \Protocol 2" $SSH_CONF
        #sed -i "/^#PermitRootLogin yes/c \PermitRootLogin no" $SSH_CONF
        #sed -i "/^PermitRootLogin yes/c \PermitRootLogin no" $SSH_CONF

        #Tell the selinux that ssh port has been changed
        yum install policycoreutils-python-2.2.5-15.el7.x86_64 -y > /dev/null
        semanage port -a -t ssh_port_t -p tcp $PORT_NUM

        #Add the port to firewall
        firewall-cmd --zone=public --add-port=$PORT_NUM/tcp --permanent > /dev/null
		firewall-cmd --reload > /dev/null
		firewall-cmd --reload > /dev/null

        #Check service
        systemctl reload sshd.service
		systemctl restart sshd.service
        if [ `systemctl status sshd.service | awk -F ' ' 'NR==3 {print $2}'` == 'active' ] ; then
                action "SSH service on: " /bin/true
        else
                action "SSH service on: " /bin/false
        fi
		
		echo -e "\e[1;32mChange ssh port has been done.\e[0m"
		echo -e "\e[1;32m+Change ssh port to: $PORT_NUM\e[0m" >> $CONFIGURED_OPTIONS
        
}


function SSH_Authorization {
        echo -n -e "\e[1;35mWarning: you are configuring to login with ssh authorization instead of password! yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
			echo -e "\e[1;35m-Configure SSH_Authorization\e[0m" >> $UNCONFIGURED_OPTIONS
            return 0
        fi

    while true; do
        echo -n -e "\e[1;34mEnter the username you want to configure: \e[0m"
        read USER_NAME
        id $USER_NAME > /dev/null
        if [[ $? == 1 ]] ; then
            echo -e "\e[1;31mThere is no user: $USER_NAME. Please add this user or re enter another username.\e[0m"
        else
            break
        fi
    done

        while [ ! -f /home/$USER_NAME/id_rsa.pub ]; do
            echo -e "\e[1;31mThere is not id_rsa.pub file in /home/$USER_NAME !\e[0m"
            echo -n -e "\e[1;34mCopy your client's certification to /home/$USER_NAME! yes or no: \e[0m"
			read COPY
			if [ $COPY == 'no' ] ; then
                return 0
			fi
        done

        SSH_CONF=/etc/ssh/sshd_config
        if [ -f $SSH_CONF.bakk ]; then
                rm -f $SSH_CONF
                mv $SSH_CONF.bakk $SSH_CONF
        fi
        cp $SSH_CONF $SSH_CONF.bakk
        sed -i "/^#PermitRootLogin yes/c \PermitRootLogin no" $SSH_CONF
        sed -i "/^#StrictModes yes/c \StrictModes no" $SSH_CONF
        sed -i "/^#RSAAuthentication yes/c \RSAAuthentication yes" $SSH_CONF
        sed -i "/^#PubkeyAuthentication yes/c \PubkeyAuthentication yes" $SSH_CONF
        sed -i "/^AuthorizedKeysFile/c \AuthorizedKeysFile      .ssh/authorized_keys" $SSH_CONF
        sed -i "/^#PasswordAuthentication yes/c \PasswordAuthentication no" $SSH_CONF


    if [[ ! -d /home/$USER_NAME/.ssh ]]; then
        mkdir /home/$USER_NAME/.ssh
        chown -R $USER_NAME:$USER_NAME  /home/$USER_NAME/.ssh/
        chmod 700  /home/$USER_NAME/.ssh
    fi
    
    cat /home/$USER_NAME/id_rsa.pub >> /home/$USER_NAME/.ssh/authorized_keys
    chmod 644  /home/$USER_NAME/.ssh/authorized_keys
    chown -R $USER_NAME:$USER_NAME  /home/$USER_NAME/.ssh/authorized_keys

    sudo systemctl restart sshd.service
	
	echo -e -n "\e[1;35mEnter the password for your certification: \e[0m"
	read PASSWORD_SSH
    echo -e "\e[1;32mSSH_Certification configure finished.\e[0m"
	echo -e "\e[1;32m+Configure SSH_Authorization, username:$USER_NAME, password:$PASSWORD_SSH\e[0m" >> $CONFIGURED_OPTIONS
}

function Secure_Set {
    echo -e "\e[1;33mChecking the status of firewall...\e[0m"
	FIREWALL_STATUS=`systemctl status firewalld | awk -F ' ' 'NR==3 {print $2}'` 
    if [ $FIREWALL_STATUS == 'active' ] ; then
        action "Firewall on: " /bin/true
	else
        action "Firewall on: " /bin/false
    fi

    #Active firewall now?
    echo -n -e "\e[1;34mActive firewall? yes or no: \e[0m"
    read FIREWALL_START
    if [[ $FIREWALL_START == 'yes' && $FIREWALL_STATUS != 'active' ]] ; then
        systemctl start firewalld
        echo -e "\e[1;32mFirewall is actived now\e[0m"
    elif [[ $FIREWALL_START == 'no' && $FIREWALL_STATUS == 'active' ]] ; then 
        systemctl stop firewalld
        echo -e "\e[1;31mFirewall is not actived now\e[0m"
    fi

    #Enable fireall startup with boot?
    echo -n -e "\e[1;34mEnable firewall startup with boot? yes or no: \e[0m"
    read FIREWALL_ENABLE
    if [ $FIREWALL_ENABLE == 'yes' ] ; then
        systemctl enable firewalld > /dev/null
        echo -e "\e[1;32mFirewall will be actived with boot now\e[0m"
    else
        systemctl disable firewalld > /dev/null
        echo -e "\e[1;31mFirewall will not be actived with boot now\e[0m"
    fi
	
	echo -e "\e[1;33mChecking the status of selinux...\e[0m"
     SELINUX_STATUS=`getenforce`
    if [ $SELINUX_STATUS == "Enforcing" ] ; then
        action "Selinux on: " /bin/true
    else
        action "Selinux on: " /bin/false
    fi
    echo -n -e "\e[1;34mActive Selinux? yes or no: \e[0m"
    read SELINUX

    SELINUX_CONF=/etc/selinux/config
    if [[ $SELINUX == 'yes' && $SELINUX_STATUS != "Enforcing" ]] ; then
        setenforce 1
        sed -i '/^SELINUX/c \SELINUX=enforcing' $SELINUX_CONF
        echo -e "\e[1;32mSelinux is actived now and will be actived with boot\e[0m"
    elif  [[ $SELINUX == 'no' && $SELINUX_STATUS == "Enforcing" ]] ; then
        setenforce 0
        sed -i '/^SELINUX/c \SELINUX=disabled' $SELINUX_CONF
        echo -e "\e[1;31mSelinux is not actived now and will not be actived with boot\e[0m"
    fi
	
	#Cannot add user.
    #chattr +i /etc/passwd
    #chattr +i /etc/shadow
    #chattr +i /etc/group
    #chattr +i /etc/gshadow
    
    #Lock system for 3 minutes after 5 fail login
	cp /etc/pam.d/login  /etc/pam.d/login.bak
	sed -i '2i auth required pam_tally2.so deny=5 unlock_time=180 even_deny_root root_unlock_time=180' /etc/pam.d/login
    echo -e "\e[1;32m+Lock system for 3 minutes after 5 fail login\e[0m" >> $CONFIGURED_OPTIONS
	
    #logout in 20 minutes after no operations
    echo "TMOUT=1200" >>/etc/profile
	echo -e "\e[1;32m+logout in 20 minutes after no operations\e[0m" >> $CONFIGURED_OPTIONS
    
    #Only record 10 commands in history
    sed -i "s/HISTSIZE=1000/HISTSIZE=10/" /etc/profile
	echo -e "\e[1;32m+Only record 10 commands in history\e[0m" >> $CONFIGURED_OPTIONS
    
    #Active the configuration
    source /etc/profile
    
    #Active syncookie in /etc/sysctl.conf 
    echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf
    sysctl -p 
	echo -e "\e[1;32m+Active syncookie in /etc/sysctl.conf \e[0m" >> $CONFIGURED_OPTIONS
    
    #Optimize sshd_config
    sed -i "s/#MaxAuthTries 6/MaxAuthTries 6/" /etc/ssh/sshd_config
    sed -i  "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config
    
    #Secure the history file 
    chattr +a /root/.bash_history
    chattr +i /root/.bash_history 
	echo -e "\e[1;32m+Cannot change file: /root/.bash_history\e[0m" >> $CONFIGURED_OPTIONS

    #Protect /var/log/secure & /var/log/audit/audit.log
    cat > /etc/logrotate.d/admin <<EOF
/var/log/audit/audit
/var/log/secure
{
    size=1000M  <==檔案容量大於 10M 則開始處置
    rotate 5  <==保留五個！
    compress  <==進行壓縮工作！
    sharedscripts
    prerotate
            /usr/bin/chattr -a /var/log/secure.log
    endscript
    sharedscripts
    postrotate
            /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
            /usr/bin/chattr +a /var/log/secure.log
    endscript
}
EOF

    sed -i "s#/var/log/secure##"  /etc/logrotate.d/syslog 
	
	echo -e "\e[1;32mSecure setting has been done.\e[0m"
}

function Grub_Lock {
        GRUB2_CONF=/boot/grub2/grub.cfg
        GRUB_CONF=/etc/grub.d/10_linux
        echo -n -e "\e[1;35mWarning: you are adding a lock to grub, yes or no: \e[0m"
        read CHOICE
        if [ $CHOICE == 'no' ] ; then
			echo -e "\e[1;35m-Add lock to grub\e[0m" >> $UNCONFIGURED_OPTIONS
            return 0
        fi

        #Backup the origional configure file
        if [[ -f $GRUB_CONF.bak && -f $GRUB2_CONF.bak ]] ; then
            rm -f $GRUB_CONF
            rm -f $GRUB2_CONF
            mv $GRUB_CONF.bak $GRUB_CONF
            mv $GRUB2_CONF.bak $GRUB2_CONF
        fi
        cp $GRUB_CONF $GRUB_CONF.bak
        cp $GRUB2_CONF $GRUB2_CONF.bak

        while true; do
            echo -n -e "\e[1;34mEnter the username for grub: \e[0m"
            read GRUB_USERNAME
            echo -n -e "\e[1;34mEnter the password for grub: \e[0m"
            read GRUB_PASSWD

            echo -e "\e[1;36m*******Check the Input*******\e[0m"
            echo -e "\e[1;36m       Username=$GRUB_USERNAME\e[0m"
            echo -e "\e[1;36m       Password=$GRUB_PASSWD\e[0m"

            echo -n -e "\e[1;34mEnter yes to continue, Enter no to input again: \e[0m"
            read CHECK
                if [ $CHECK == 'yes' ] ; then
                    break;
                fi
        done

#Create encrypted password
echo "$GRUB_PASSWD
$GRUB_PASSWD
" | grub2-mkpasswd-pbkdf2 > tmpfile

    #Write the encrypted password to file
    GRUB_ENCRYPT_PASSWD=`cat tmpfile | awk -F ' ' 'NR==3 {print $7}'`
    echo 'cat <<EOF' >> $GRUB_CONF
    echo "set superusers=$GRUB_USERNAME" >> $GRUB_CONF
    echo "password_pbkdf2 $GRUB_USERNAME $GRUB_ENCRYPT_PASSWD" >> $GRUB_CONF
    echo 'EOF' >> $GRUB_CONF

    grub2-mkconfig --output=/boot/grub2/grub.cfg 
    rm -f tmpfile
	
	echo -e "\e[1;32mAdding a lock to grub has been done.\e[0m"
	echo -e "\e[1;32m+Add lock to grub. username: $GRUB_USERNAME,password:$GRUB_PASSWD \e[0m" >> $CONFIGURED_OPTIONS
}

#Call the function
Update_System
Add_User_As_Root 
Change_SSH_Port 
SSH_Authorization
Secure_Set
Grub_Lock

