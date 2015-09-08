#!/bin/bash
# Author:       kylin
# E-mail:       kylinlingh@foxmail.com
# Blog:         http://www.cnblogs.com/kylinlin
# Github:       https://github.com/Kylinlin
# Date:         2015/9/8          
# Version:      
# Function:     Configure vim template
################################################

VIM_CONF=/etc/vimrc
TEMPLATE=/etc/kylin_vim.conf

cp $VIM_CONF $VIM_CONF.bak
sed -i "28a autocmd BufNewFile *.sh 0r $TEMPLATE" $VIM_CONF
echo "set tabstop=4" >> $VIM_CONF
echo "set softtabstop=4" >> $VIM_CONF
echo "set shiftwidth=4" >> $VIM_CONF
echo "set autoindent" >> $VIM_CONF
cat >$TEMPLATE<<EOF
#!/bin/bash
# Author:        kylin
# E-mail:        kylinlingh@foxmail.com
# Blog:          http://www.cnblogs.com/kylinlin
# Github:        https://github.com/Kylinlin
# Date:          
# Version:      
# Function:      
################################################
EOF