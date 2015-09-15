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

Plugin 'scrooloose/nerdtree'                "文件目录树
Plugin 'mbbill/undotree'                    "操作记录树
Plugin 'ctrlp.vim'                          "文件查找
Plugin 'tacahiroy/ctrlp-funky'              "函数搜索
Plugin 'scrooloose/nerdcommenter'           "添加注释
Plugin 'scrooloose/syntastic'               "语法检查
"Plugin 'tpope/vim-fugitive'                "用来操作github
Plugin 'Valloric/YouCompleteMe'             "自动补全
Plugin 'mileszs/ack.vim'                    "文件搜索插件
Plugin 'godlygeek/tabular'                  "自动调整格式
Plugin 'majutsushi/tagbar'                  "检索文件内的标签
Plugin 'easymotion/vim-easymotion'          "快速跳转

call vundle#end()            " required
filetype plugin indent on    " required


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"设置vim 主题颜色
"colorscheme Tomorrow-Night-Eighties 
"colorscheme Tomorrow 
"colorscheme Tomorrow-Night-Blue 
"colorscheme Tomorrow-Night-Bright 
"colorscheme Tomorrow-Night 

set t_Co=256

"molokai
"colorscheme molokai
"set background=dark


"Solarized"
colorscheme solarized
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"
set background=light

syntax enable 
set cul                                                         "高亮光标所在行
set cuc
set shortmess=atI                                       " 启动的时候不显示那个援助乌干达儿童的提示  
""set go=                                               " 不要图形按钮  

"set guifont=Courier_New:h10:cANSI  " 设置字体  
set guifont=Monospace\ 24

"autocmd InsertLeave * se nocul         " 用浅色高亮当前行  
autocmd InsertEnter * se cul            " 用浅色高亮当前行  
set ruler                                       " 显示标尺  
set showcmd                                     " 输入的命令显示出来，看的清楚些  
"set whichwrap+=<,>,h,l                         " 允许backspace和光标键跨越行边界(不建议)  
set scrolloff=3                                 " 光标移动到buffer的顶部和底部时保持3行距离  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=2                                " 启动显示状态行(1),总是显示状态行(2)  
set foldenable                                  " 允许折叠  
set foldmethod=manual                           " 手动折叠  
 
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

func AddComment() 
                call append(line("."), "###############################################################") 
                call append(line("."), "#Description    :") 
                call append(line("."), "#Version        :") 
                call append(line("."), "#Github         :   https://github.com/Kylinlin") 
                call append(line("."), "#Email          :   kylinlingh@foxmail.com") 
                call append(line("."), "#Created Time   :   ".strftime("%c")) 
                call append(line("."), "#Arthor         :   kylin") 
                call append(line("."), "#File Name      :   ".expand("%")) 
                call append(line("."), "###############################################################") 
    endfunc

func SetTitle() 
        "如果文件类型为.sh文件 
        if &filetype == 'sh' 
                call setline(1,"\#!/bin/bash") 
            call append(line("."), "")
        call AddComment()

    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python")
        call AddComment()
            call append(line("."), "")
        call append(line("."),"# coding=utf-8")

    elseif &filetype == 'ruby'
        call setline(1,"#!/usr/bin/env ruby")
        call AddComment()
            call append(line("."), "")
        call append(line("."),"# encoding: utf-8")

"    elseif &filetype == 'mkd'
"        call setline(1,"<head><meta charset=\"UTF-8\"></head>")
        else 
                call setline(1, "/*************************************************************************") 
                call append(line("."),   "File Name     :   ".expand("%")) 
                call append(line(".")+1, "Author        :   kylin") 
                call append(line(".")+2, "Created Time  :   ".strftime("%c")) 
                call append(line(".")+3, "Email         :   kylinlingh@foxmail.com") 
                call append(line(".")+4, "Github        :   https://github.com/Kylinlin")
        call append(line(".")+5 ,"Version       :")
        call append(line(".")+6 ,"Description   :")
                call append(line(".")+7, " ************************************************************************/") 
                call append(line(".")+8, "")
        endif
        if expand("%:e") == 'cpp'
                call append(line(".")+9, "#include<iostream>")
                call append(line(".")+10, "using namespace std;")
                call append(line(".")+11, "")
        endif
        if &filetype == 'c'
                call append(line(".")+9, "#include<stdio.h>")
                call append(line(".")+10, "")
        endif
        if expand("%:e") == 'h'
                call append(line(".")+9, "#ifndef _".toupper(expand("%:r"))."_H")
                call append(line(".")+10, "#define _".toupper(expand("%:r"))."_H")
                call append(line(".")+11, "#endif")
        endif
        if &filetype == 'java'
                call append(line(".")+9,"public class ".expand("%:r"))
                call append(line(".")+10,"")
        endif
        "新建文件后，自动定位到文件末尾
endfunc 
autocmd BufNewFile * normal G


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fenc=utf-8
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936 " 设置文件编码格式，以防止中文乱码
set guioptions-=T                                " 隐藏工具栏
set guioptions-=m                                " 隐藏菜单栏
set confirm                                      " 在处理未保存或只读文件的时候，弹出确认
set nobackup                                     " 禁止生成临时文件
set noswapfile
set ignorecase                                   " 搜索忽略大小写
set showmatch                                    " 高亮显示匹配的括号
set matchtime=1                                  " 匹配括号高亮的时间（单位是十分之一秒）
let mapleader = ','                              " 设置逗号为<leader>键


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

set statusline+=%#warningmsg#               "配置语法检查
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py '                                "配置YouCompleteMe



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""快捷键设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F4> :w<cr>:!sh %<cr>     " F4一键运行shell脚本                    "
map <F5> :w<cr>:!python %<cr> " F5一键运行python程序                   "
set pastetoggle=<F9>          " 设置F9键为缩进快捷键，用来处理复制文件 "
nmap <F8> :TagbarToggle<CR>   " 设置F8键为打开标签快捷键