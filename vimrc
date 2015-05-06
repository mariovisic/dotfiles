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

  " Press ` twice to toggle the previous buffer
  map `` <C-^>

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

  " Show invisible characters
  set list

  " Set which invisible characters to show
  set listchars=""
  set listchars=tab:\ \
  set listchars+=trail:.
  set listchars+=extends:>
  set listchars+=precedes:<

  " Highlight incrimental searches and use smart case matching
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase

  " Ignore files in git and tmp files or sass cache
  set wildignore+=*/.git/*
  set wildignore+=*/tmp/*
  set wildignore+=*/.sass-cache/*

"""""""""""""""""""""""""
" Other editor settings "
"""""""""""""""""""""""""

  " Directories for swp files
  set backupdir=~/.vimbackup
  set directory=~/.vimbackup

  " Reload vim after editing the vimrc
  au! BufWritePost .vimrc source %
  au! BufWritePost .gvimrc source %


""""""""""""
" NERDTREE "
""""""""""""

  " Open on boot if no file is specified
  autocmd vimenter * if !argc() | NERDTree | endif

  let g:nerdtree_tabs_open_on_gui_startup=0

"""""""""""""""""
" Vim Powerline "
""""""""""""""""" 

  " This allows the powerline to always be shown (not just when a split is open).
  set laststatus=2

"""""""
" Ack "
"""""""

  " Command + Shift + F opens ack search
  nmap <D-F> :Ack<space>

"""""""""
" ctrlp "
"""""""""

  " Ignore temoprary swap and zip files
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip

  " Ignore bundler cached gems
  set wildignore+=*/vendor/cache/*

  " Ignore the git folder
  set wildignore+=*/.git/*

  " Ignore Jasmine headless temporary files
  set wildignore+=*/.jhw-cache/*

  " Use faster C matcher
  let g:ctrlp_match_func = {'match' : 'matcher#cmatch'}
