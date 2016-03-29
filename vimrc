" Vundle settings
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Plugin list
call vundle#begin()
"Plugin 'VundleVim/Vundle.vim'
"Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'bling/vim-airline'
"Plugin 'Valloric/YouCompleteMe'
call vundle#end()
filetype plugin indent on

" Syntax highlighting premanent
syntax on

" Set backup file location
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Set color shema
colorscheme desert

