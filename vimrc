""""""""""""
" Pathogen "
""""""""""""

  " Enable pathogen for loading plugins
  call pathogen#infect()
  call pathogen#helptags()


"""""""""""""""""""""""""""""
" Editor appearance changes "
"""""""""""""""""""""""""""""

  " Remove left scrollbars
  set guioptions-=L

  " Remove the top toolbar
  set guioptions-=T

  " Default font
  set guifont=Monaco:h14.00

  " Color scheme
  color getafe

  " Show line numbers
  set number

"""""""""""""""""""
" Custom Mappings "
"""""""""""""""""""

  " Clear highlighted search items by pressing space
  nmap <SPACE> <SPACE>:noh<CR>

  " \n to toggle Nerdtree
  nmap <Leader>n :NERDTreeToggle<CR>

  " Remove the functionality of the escape key (This should  force me to use
  " ctrl+c and ctrl+[ instead of reaching for escape)
  imap <ESC> <Nop>


"""""""""""""""""""""""""
" Basic editor settings "
"""""""""""""""""""""""""

  " Highlight syntax
  syntax on

  " Indent based on file type
  filetype plugin indent on

  " Default indent settings (2 spaces with no tabs)
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
  set expandtab

  " Do not wrap lines by default
  set nowrap

"""""""""""""""""""""""""
" Other editor settings "
"""""""""""""""""""""""""

  " Directories for swp files
  set backupdir=~/.vimbackup
  set directory=~/.vimbackup


""""""""""""
" NERDTREE "
""""""""""""

  " Open on boot if no file is specified
  autocmd vimenter * if !argc() | NERDTree | endif

  let g:nerdtree_tabs_open_on_gui_startup=0
