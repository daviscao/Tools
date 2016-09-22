set nocompatible
color murphy
:colorscheme darkblue
syn on
set nowrap
set guioptions+=b
""set lbr
set incsearch
set autoindent
set shiftwidth=4
set hlsearch
set history=50
filetype plugin indent on
set nu   
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
set clipboard+=unnamed
syntax enable
syntax on
set guifont=Courier_New\ h20
"":et guifont =14
""""""""""""""""""""""""""""""""""""""""""""""""""
"function  <1>	:add file header 
""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufNewFile *.cpp,*.[ch],*.pl,*.tcl,*.sh,*.csh exec ":call SetTitle()"

func SetTitle()
    if &filetype =='c'|| &filetype =='h'|| &filetype =='cpp'
	call setline(1,         "\/*************************************************************************")
	call append(line("."),  "\*  File Name    : " .expand("%:t"))
	call append(line(".")+1,"\*  Description  : ")
	call append(line(".")+2,"\*               : ")
	call append(line(".")+3,"\*  Author Name  : Davis Cao")
	call append(line(".")+4,"\*  Email        : daviscao@zhaoxin.com")
	call append(line(".")+5,"\*  Create Date  : ".strftime("%Y-%m-%d %H:%M"))
	call append(line(".")+6,"\*************************************************************************/")
    elseif &filetype == 'perl'|| &filetype =='tcl' ||&filetype =='sh'|| &filetype =='csh'
	call append(line("."),  "\##########################################################################")
	call append(line(".")+1,"\#  File Name    : ".expand("%:t"))
	call append(line(".")+2,"\#  Description  : ")
	call append(line(".")+3,"\#               : ")
	call append(line(".")+4,"\#  Author Name  : Davis Cao")
	call append(line(".")+5,"\#  Email        : daviscao@zhaoxin.com")
	call append(line(".")+6,"\#  Create Date  : ".strftime("%Y-%m-%d %H:%M"))
	call append(line(".")+7,"\##########################################################################")
	call append(line(".")+8,"")
    endif
    
    if &filetype =='c'
	call append(line(".")+7,"\#include <stdio.h>")
	call append(line(".")+8,"")
    elseif &filetype =='cpp'
	call append(line(".")+7,"\#include <iostream.h>")
	call append(line(".")+8,"using namespace std")
	call append(line(".")+9,"")
    elseif &filetype =='perl'
	call setline(1,"\#!/usr/bin/perl -w")
    elseif &filetype =='tcl'
	call setline(1,"\#!/usr/bin/tclsh")
    elseif &filetype =='sh'
	call setline(1,"\#!/bin/bash -f")
    elseif &filetype =='csh'
	call setline(1,"\#!/bin/csh -f")
    endif

endfunc SetTitle

autocmd BufNewFile * normal G

":set comments=n:#,n://
""""""""""""""<1.1> :add modify information"""""""""""""""
map md /Create Date/  <ENTER> $a<ENTER>Modifier     > Davis Cao<ENTER>Modify Info  > <ENTER>Modify Date  ><ESC>:read !date<CR>kJ :<ESC>G<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
"function  <2>	:File fold
""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable
set foldlevel=100       
set foldcolumn=5

""set foldmethod=manual "used for unformated file,you can define any fold as you like
"command <zf>:
"  ->put the cursor on a begin line
"  ->tpye z f
"  ->put the cursor on the end line
"  ->then the section between is folded

"set foldmethod=syntax
"set foldmethod=indent
"set foldmethod=expc
"set foldmethod=diff

set foldmethod=marker
"set foldmarker={{{,}}}

"command <za>:open or close an exited fold ?
"command <zA> 
"command <zo> ?
"command <zc>
"command <zM>?
"command <zR>?

""""""""""""""""""""""""""""""""""""""""""""""""""
"function  <3>	:()[]{}''"" Punctuation Autocomplete
""""""""""""""""""""""""""""""""""""""""""""""""""
"one way:  \+1=()  \+2=[]  \+3={}  \+4={ \n  }  \+q=''  \+w=""
inoremap <leader>1 ()<esc>:let leavechar=")"<cr>i
inoremap <leader>2 []<esc>:let leavechar="]"<cr>i
inoremap <leader>3 {}<esc>:let leavechar="}"<cr>i
inoremap <leader>4 {<esc>o}<esc>:let leavechar="}"<cr>O
inoremap <leader>q ''<esc>:let leavechar="'"<cr>i
inoremap <leader>w ""<esc>:let leavechar='"'<cr>i
"the other way (=() [=[] {={} '='' ...
:inoremap ( ()<ESC>i
:inoremap { {<CR>}<ESC>O
:inoremap [ []<ESC>i
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i

""""""""""""""""""""""""""""""""""""""""""""""""""
"function  <4>	:One-Hot key to run complete,run and debug
""""""""""""""""""""""""""""""""""""""""""""""""""
" F5 to compile and run c,c++,java,sh file
" F8 to debug 
" Attention:The code below will have error under WINDOWS OS
" 	    You can delete the "./" to run under WINDOWS OS
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!java %<"
    elseif &filetype == 'sh'
        :!./%
    endif
endfunc
"C,C++
map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc

""""""""""""""""""""""""""""""
" mark setting(not work)
""""""""""""""""""""""""""""""
nmap <silent> <leader>hl <Plug>MarkSet
vmap <silent> <leader>hl <Plug>MarkSet
nmap <silent> <leader>hh <Plug>MarkClear
vmap <silent> <leader>hh <Plug>MarkClear
nmap <silent> <leader>hr <Plug>MarkRegex
vmap <silent> <leader>hr <Plug>MarkRegex

""""""""""""""""""""""""""""""""""""""""""""""""""
"function  <5>	:add sv syntax 
""""""""""""""""""""""""""""""""""""""""""""""""""
 source /u/easonz/utility/systemverilog.vim
 
 augroup filetypedetect
         au! BufNewFile,BufRead *.sv,*.svh,*.lib
         " au BufNewFile,BufRead *.sv,*.svh   setf systemverilog
         au BufNewFile,BufRead *.log,*.vh,*.template        setf systemverilog
         au BufNewFile,BufRead *.syn        setf verilog
         au BufNewFile,BufRead *.dofile,*.con        setf tcl
         au BufNewFile,BufRead *.vb,*.src,*.vmd        setf verilog
         au BufNewFile,BufRead vec.*,*.sv,*.svh,*.log,*.lib   source /u/easonz/utility/systemverilog.vim
         " au BufNewFile,BufRead vec.*     setf verilog
 augroup END
"""""""""""""""""""""""""""""""""""""""""""""""""""


" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif
set ffs=unix,dos,mac

set guifont=-adobe-courier-medium-r-normal--18-180-75-75-m-110-iso8859-1

