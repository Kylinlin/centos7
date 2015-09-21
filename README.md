###安装说明
+ 1.直接在终端运行命令就可以安装： wget -qO- https://raw.github.com/Kylinlin/centos7/master/setup.sh | sh -x 

###配置内容
+ 更新系统和软件
+ 添加第三方yum源
+ 添加具有root权限的用户
+ 更改ssh端口
+ 配置使用ssh证书登陆，禁止远程root登陆和密码登陆
+ 检查配置防火墙和selinux
+ 3次登陆失败后将锁定5分钟
+ 20分钟内无任何信息将自动登出
+ 使用syncookie
+ 只显示最近的10条命令历史记录
+ 禁止修改记录历史命令的文件
+ 给grub引导界面加上锁，禁止无密码使用单人模式
