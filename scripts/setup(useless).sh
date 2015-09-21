#!/bin/bash
###############################################################
#File Name      :   setup.sh
#Arthor         :   kylin
#Created Time   :   Wed 16 Sep 2015 10:50:16 AM CST
#Email          :   kylinlingh@foxmail.com
#Github         :   https://github.com/Kylinlin
#Version        :
#Description    :
###############################################################

function Show_Interface {
    echo -e "\e[1;36m+--------------------------------------------------------------+"
    echo -n "BEFORE WE BEGIN, SELECT YOUR LANGUAGE(1 FOR CHINESE, 2 FOR ENGLISH): " 
    read ENTER_LAN
    echo -e "\e[1;36m+--------------------------------------------------------------+\e[0m"
    if [[ $ENTER_LAN == 1 ]]; then
        echo "export LANGUAGE=en" > choices
    else
        echo "export LANGUAGE=us" > choices
    fi
}

function Chinese_Interface_ {

    AStr="更新系统软件"
    BStr="添加第三方软件源"
    CStr="添加具有root权限的用户"
    DStr="更改SSH端口"
    EStr="调整系统打开文件数"
    FStr="设置系统同步时间"
    GStr="优化系统内核"
    HStr="安装系统工具"
    IStr="禁止使用IPV6"
    JStr="一键初始化"

    echo -e "\e[1;32m+--------------------------------------------------------------+"
    echo "+-----------------欢迎对系统进行初始化安全设置！---------------+"
    echo ""
    echo "      A：${AStr}"
    echo "      B：${BStr}"
    echo "      C：${CStr}"
    echo "      D：${DStr}"
    echo "      E：${EStr}"
    echo "      F：${FStr}"
    echo "      G：${GStr}"
    echo "      H：${HStr}"
    echo "      I：${IStr}"
    echo "      J：${JStr}"
    echo ""
    echo "+--------------------------------------------------------------+"

    option="-1"
    read -n1 -t20 -p "请选择初始化选项【A-B-C-D-E-F-G-H-I-J】:" option
    flag1=$(echo $option|egrep "\-1"|wc -l)
    flag2=$(echo $option|egrep "[A-Ja-j]"|wc -l)
    if [ $flag1 -eq 1 ];then
        option="K"
    elif [ $flag2 -ne 1 ];then
        echo -e "\n\n请重新运行脚本，输入从A--->J的字母！"
        exit 1
    fi
    echo -e "\n你选择的选项是：$option\n"
    echo "5秒之后开始安装 ......"
    sleep 5
    
}

function Chinese_Interface {
    echo -e "\e[1;32m+----------------------------------------------------------------+\\r
===================本安装程序将执行以下的操作=====================\\r
||                                                              || 
||        A:提升系统安全性                                      || 
||            A1: 更新系统软件                                  || 
||            A2: 添加可信任的第三方软件源                      || 
||            A3: 添加具有root权限的用户                        || 
||            A4: 更改SSH端口                                   || 
||            A5: 将SSH登陆方式改为证书登陆                     || 
||            A6: 检查并操作防火墙（开启/关闭）                 || 
||            A7: 检查并操作SELinux （开启/关闭）               || 
||            A8: 给GRUB引导界面加锁                            || 
||                                                              || 
||        B:普通配置                                            || 
||            B1: 配置网络的静态IP                              || 
||            B2: 配置主机名                                    || 
||                                                              || 
||                                                              || 
||        C:搭建软件运行环境                                    || 
||            C1: 安装常用软件包                                || 
||            C2: 安装编译环境（编译器和库）                    || 
||            C3: 安装web管理工具(webmin)                       || 
||            C4: 安装LMAP(Apache,Mysql,Php)                    || 
||                                                              || 
||        D:安装安全软件                                        || 
||            D1: 安装端口扫描工具(Nmap)                        || 
||            D2: 安装木马扫描器(Rootkit)                       || 
||            D3: 安装恶意程序扫描器(LMD)                       || 
||            D4: 安装杀毒引擎(ClamAV)                          || 
=================================================================="

    echo -e "\e[1;31m+----------------------------------------------------------------+\e[0m"
    echo -e "\e[1;31m注意：如果没有选择初始化选项，20秒后将自动选择一键初始化安装！\e[0m"
    echo -e "\e[1;31m+--  ------------------------------------------------------------+\e[0m"

}

Interface