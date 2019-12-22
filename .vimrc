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
