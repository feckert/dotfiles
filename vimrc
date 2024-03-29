" Vundle settings
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Plugin list
call vundle#begin()
"Plugin 'VundleVim/Vundle.vim'
Plugin 'mileszs/ack.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ap/vim-buftabline'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
call vundle#end()
filetype plugin indent on

set encoding=utf-8

" Plugin settings airline
let g:airline_theme='powerlineish'
let g:airline_enable_branch=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline_powerline_fonts = 1

" Plugin settings ctrlp
let g:ctrlp_working_path_mode='ra'

" File Browser settings
let g:netrw_liststyle=3

" Show whitespace char
set listchars=tab:\|.,trail:.,extends:>,precedes:<
set list

" Set char highlight columne
set colorcolumn=80

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
set background=dark
set t_Co=256

" Set backup file location
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Set color shema
colorscheme industry

" Donot select line number and windows
set ttymouse=xterm2
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
nmap <leader>bq :bp <BAR> bw #<CR>
nmap <leader>bl :ls<CR>

" Show Filebrowser
nmap <leader>k :E<cr>

" Nerdtree shortcuts
map <C-n> :NERDTreeToggle <CR>

" Nerdtree show dot files
let NERDTreeShowHidden=1

" ack search word under the cursor
noremap <leader>a :Ack <cword><CR>

