"""""""""""""""""""""""""""""
" Editor appearance changes "
"""""""""""""""""""""""""""""

  " Remove left scrollbars
  set guioptions-=L

  " Remove the top toolbar
  set guioptions-=T

  " Default font
  set guifont=Monaco:h18.00

  " Color scheme
  color getafe

  " Show line numbers
  set number

"""""""""""""""""""
" Custom Mappings "
"""""""""""""""""""

  " Clear highlighted search items by pressing space
  nmap <SPACE> <SPACE>:noh<CR>

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

  " Show graphical menu when autocompleting
  set wildmenu

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

  " Spell check git commit messages
  autocmd FileType gitcommit setlocal spell
