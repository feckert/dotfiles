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

" Plugin settings airline
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'

" Plugin settings ctrlp
let g:ctrlp_working_path_mode='ra'

" Plugin airline theme
"let g:airline_theme='jellybeans'
let g:airline_theme='term'

" File Browser settings
let g:netrw_liststyle=3

" Show whitespace char
set listchars=tab:\|.,trail:.,extends:>,precedes:<
set list

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
colorscheme industry

" Donot select line number and windows
set mouse=a

" Allow changing buffer selection
set hidden

" Add space leader key for commands
let mapleader = "\<Space>"

" Shortcuts for CtrlP Plugin
nmap <leader>cm :CtrlPMix ed<CR>
nmap <leader>cb :CtrlPBuffer<CR>

" Shortcuts for Buffer handling
nmap <leader>bt :enew<CR>
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

" Show Filebrowser
nmap <leader>k :E<cr>
