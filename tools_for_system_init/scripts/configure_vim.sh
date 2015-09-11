#!/bin/bash
# Author:       kylin
# E-mail:       kylinlingh@foxmail.com
# Blog:         http://www.cnblogs.com/kylinlin
# Github:       https://github.com/Kylinlin
# Date:     2015/9/8          
# Version:      
# Function:     Configure vim template
################################################

VIM_CONF=/etc/vimrc
TEMPLATE=/etc/kylin_vim.conf

if [ -f $VIM_CONF.bak ] ; then
    rm -f $VIM_CONF
    mv $VIM_CONF.bak
fi

#
cp $VIM_CONF $VIM_CONF.bak
sed -i "28a autocmd BufNewFile *.sh 0r $TEMPLATE" $VIM_CONF
echo "set tabstop=4" >> $VIM_CONF
echo "set softtabstop=4" >> $VIM_CONF
echo "set shiftwidth=4" >> $VIM_CONF
echo "set autoindent" >> $VIM_CONF

#注释的开头
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
                                    
#增加中文输入法，用法：Ctrl+/切换输入法
cd ../packages/others
PLUGIN_DIR=/usr/share/vim/vim74/plugin
cp vimim.vim $PLUGIN_DIR