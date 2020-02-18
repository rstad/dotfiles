set history=500
filetype plugin on
filetype indent on
set ruler
set number
set hlsearch
set showmatch
set incsearch
syntax enable
set laststatus=2
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
" yaml settings
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" below is stuff recommended for work
set autoindent " keep indentation when starting new lines
set tabstop=2 " spaces per tab
set softtabstop=1 " spaces per tab (when tabbing/backspacing)
set shiftwidth=2 " spaces per tab (when shifting)
set expandtab " always use spaces instead of tabs
set list " show whitespace
set listchars=nbsp:¬,tab:>-,extends:»,precedes:«,trail:•
