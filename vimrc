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
