" Remove left scrollbars
set guioptions-=L

" Remove the top toolbar
set guioptions-=T

" Default font
set guifont=Monaco:h14.00

" Clear highlighted search items by pressing space
nmap <SPACE> <SPACE>:noh<CR>

" Directories for swp files
set backupdir=~/.vimbackup
set directory=~/.vimbackup

" Remove the functionality of the escape key (This should  force me to use
" ctrl+c and ctrl+[ instead of reaching for escape)
imap <ESC> <Nop>

color getafe

" Enable pathogen for loading plugins
call pathogen#infect()
call pathogen#helptags()

" Highlight syntax
syntax on

" Indent based on file type
filetype plugin indent on

" Show line numbers
set number

" Default indent settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

""""""""""""
" NERDTREE "
""""""""""""

  " \n to toggle
  nmap <Leader>n :NERDTreeToggle<CR>

  " Open on boot if no file is specified
  autocmd vimenter * if !argc() | NERDTree | endif

  let g:nerdtree_tabs_open_on_gui_startup=0
