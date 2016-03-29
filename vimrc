" Vundle settings
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Plugin list
call vundle#begin()
"Plugin 'VundleVim/Vundle.vim'
"Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'bling/vim-airline'
"Plugin 'Valloric/YouCompleteMe'
call vundle#end()
filetype plugin indent on

" Plugin settings
let g:airline#extensions#tabline#enabled=1

" Code display settings
syntax on " Syntax highlighting premanent
set showmatch " Shows brackets

" General display settings
set title " Show title
set showmode " Show mode
set ruler " Show cursor position
set cursorline " Highlight line with cursor
set number " Show line number
set laststatus=2 "Always show the status line

" Set backup file location
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Set color shema
colorscheme desert

