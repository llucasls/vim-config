" Enable file type detection
filetype on

syntax enable
colorscheme gruvbox
set background=dark
set termguicolors

set number
set relativenumber

set hidden
set expandtab
set autoindent
set softtabstop=4
set shiftwidth=2
set tabstop=4
let &scrolloff = printf('%.f', round(winheight(0) / 3.0))

set clipboard=unnamedplus
set colorcolumn=80

" Enable mouse click for vim
set mouse=a

"See invisible characters
set list listchars=tab:»\ ,trail:+,eol:$

" Wrap to next line when end of line is reached
set whichwrap+=<,>,[,]

if &term !=# 'alacritty'
  set guicursor=n-v-c:block-Cursor
endif
set guicursor+=i:ver100-iCursor
set guicursor+=r:hor100-rCursor

highlight Cursor guifg=#1E1E1E guibg=#E1E1E1
