###安装说明
+ 1.直接在终端运行命令克隆这个项目： wget -qO- https://raw.github.com/Kylinlin/centos7/master/setup.sh | sh -x 
+ 2.运行文件scripts/startup.sh来进行安装
+ 3.在安装的过程中需要有人值守，来确认每一步的安装

###配置内容
+ 更新系统和软件
+ 添加第三方yum源
+ 添加具有root权限的用户
+ 更改ssh端口
+ 配置使用ssh证书登陆，禁止远程root登陆和密码登陆
+ 检查配置防火墙和selinux
+ 5次登陆失败后将锁定3分钟
+ 20分钟内无任何信息将自动登出
+ 使用syncookie
+ 只显示最近的10条命令历史记录
+ 禁止修改记录历史命令的文件
+ 给grub引导界面加上锁，禁止无密码使用单人模式


###注意
+ 因为会禁止用root账户登录，所以必须添加具有root权限的用户，否则无法登陆

###安装的软件套件
+ rkhunter（rootkit猎手）检测是否感染rootkit和后门程序
  + 用法：rkhunter --check ，会生成报告文件：/var/log/rkhunter/rkhunter.log
  + 每天凌晨两点自动检测一次
+ 恶意软件检测工具LMD和杀毒引擎ClamAV
  + 每天凌晨两点自动扫描apache目录
