" Vundle settings
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Plugin list
call vundle#begin()
"Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
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

" Set airline theme
let g:airline_theme='solarized'

" Donot select line number and windows
set mouse=a

" Tab as buffer
set hidden
let mapleader = "\<Space>"
nmap <leader>pm :CtrlPMixed<CR>
nmap <leader>pb :CtrlPBuffer<CR>
nmap <leader>T :enew<CR>
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

