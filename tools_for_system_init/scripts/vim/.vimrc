"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle配置
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                        "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
"Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

Plugin 'scrooloose/nerdtree'
Plugin 'mbbill/undotree'
Plugin 'ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'      
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'spf13/vim-autoclose'
"Plugin 'tpope/vim-fugitive'  for github
Plugin 'vimim/vimim'

call vundle#end()            " required
filetype plugin indent on    " required


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on 
set cul                                                         "高亮光标所在行
set cuc
set shortmess=atI                                       " 启动的时候不显示那个援助乌干达儿童的提示  
set go=                                                 " 不要图形按钮  
"color desert                                           " 设置背景主题  
color ron                                               " 设置背景主题  
"color torte                                            " 设置背景主题  
"set guifont=Courier_New:h10:cANSI  " 设置字体  
"autocmd InsertLeave * se nocul         " 用浅色高亮当前行  
autocmd InsertEnter * se cul            " 用浅色高亮当前行  
set ruler                                       " 显示标尺  
set showcmd                                     " 输入的命令显示出来，看的清楚些  
"set whichwrap+=<,>,h,l                         " 允许backspace和光标键跨越行边界(不建议)  
set scrolloff=3                                 " 光标移动到buffer的顶部和底部时保持3行距离  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=2                                " 启动显示状态行(1),总是显示状态行(2)  
"set foldenable                                 " 允许折叠  
""set foldmethod=manual                         " 手动折叠  
 
" 显示中文帮助
if version >= 603
        set helplang=cn
        set encoding=utf-8
endif

set autoindent                                          " 自动缩进
set cindent
set tabstop=4                                           " Tab键的宽度
set softtabstop=4                                       " 统一缩进为4
set shiftwidth=4
set expandtab                                           " 用空格代替制表符
set smarttab                                            " 在行和段开始处使用制表符
set number                                                      " 显示行号
set history=1000                                        " 历史记录数
set hlsearch                                            "搜索逐字符高亮
set incsearch
set langmenu=zh_CN.UTF-8                        "语言设置
set helplang=cn
set cmdheight=2                                         " 总是显示状态行
filetype on                                                     " 侦测文件类型
filetype plugin on                                      " 载入文件类型插件
filetype indent on                                      " 为特定文件类型载入相关缩进文件
set viminfo+=!                                          " 保存全局变量
set iskeyword+=_,$,@,%,#,-                      " 带有如下符号的单词不要被换行分割



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
        "如果文件类型为.sh文件 
        if &filetype == 'sh' 
                call setline(1,"\#!/bin/bash") 
                call append(line("."), "#Description:") 
                call append(line("."), "#Version:") 
                call append(line("."), "#Github:                https://github.com/Kylinlin") 
                call append(line("."), "#Email:                 kylinlingh@foxmail.com") 
                call append(line("."), "#Created Time:") 
                call append(line("."), "#Arthor:                kylin") 

    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python")
                call append(line("."), "#Description:") 
                call append(line("."), "#Version:") 
                call append(line("."), "#Github:                https://github.com/Kylinlin") 
                call append(line("."), "#Email:                 kylinlingh@foxmail.com") 
                call append(line("."), "#Created Time:") 
                call append(line("."), "#Arthor:                kylin") 
            call append(line("."), "")
        call append(line("."),"# coding=utf-8")

    elseif &filetype == 'ruby'
        call setline(1,"#!/usr/bin/env ruby")
        call append(line("."),"# encoding: utf-8")
            call append(line(".")+1, "")

"    elseif &filetype == 'mkd'
"        call setline(1,"<head><meta charset=\"UTF-8\"></head>")
        else 
                call setline(1, "/*************************************************************************") 
                call append(line("."), "        > File Name: ".expand("%")) 
                call append(line(".")+1, "      > Author: ") 
                call append(line(".")+2, "      > Mail: ") 
                call append(line(".")+3, "      > Created Time: ".strftime("%c")) 
                call append(line(".")+4, " ************************************************************************/") 
                call append(line(".")+5, "")
        endif
        if expand("%:e") == 'cpp'
                call append(line(".")+6, "#include<iostream>")
                call append(line(".")+7, "using namespace std;")
                call append(line(".")+8, "")
        endif
        if &filetype == 'c'
                call append(line(".")+6, "#include<stdio.h>")
                call append(line(".")+7, "")
        endif
        if expand("%:e") == 'h'
                call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
                call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
                call append(line(".")+8, "#endif")
        endif
        if &filetype == 'java'
                call append(line(".")+6,"public class ".expand("%:r"))
                call append(line(".")+7,"")
        endif
        "新建文件后，自动定位到文件末尾
endfunc 
autocmd BufNewFile * normal G


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fenc=utf-8
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936 "shezhi wenjian bianma 
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
set confirm                                     " 在处理未保存或只读文件的时候，弹出确认
set nobackup                            "禁止生成临时文件
set noswapfile
set ignorecase                          "搜索忽略大小写
set showmatch                           " 高亮显示匹配的括号
set matchtime=1                         " 匹配括号高亮的时间（单位是十分之一秒）
let mapleader = ','


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""插件设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif 
map <C-n> :NERDTreeToggle<CR> "用Crtl-n打开NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif "当只剩下一个NREDTree窗口时自动关闭vim
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '>'
let g:NERDTreeDirArrowCollapsible = '<'  "改变箭头的形式
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']

map <C-u> :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0








