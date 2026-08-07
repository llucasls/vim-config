vim9script
# Enable file type detection
filetype on

runtime! ftplugin/man.vim

#syntax enable
set background=dark
set termguicolors

set number
set relativenumber

set hidden
set expandtab
set autoindent
set softtabstop=4
#set shiftwidth=2
set tabstop=4
set hlsearch
&scrolloff = float2nr(round(winheight(0) / 3.0))

set colorcolumn=80

# Enable mouse click for vim
set mouse=a

# See invisible characters
set list listchars=tab:»\ ,trail:+,eol:$
set conceallevel=1 concealcursor=

# Wrap to next line when end of line is reached
set whichwrap+=<,>,[,]

# Place swap file in one of these directories
set directory=$MYVIMDIR/tmp//,.,/var/tmp//,/tmp//

if $session_type ==# 'gui' && has('clipboard')
  set clipboard=unnamedplus
elseif $session_type ==# 'gui' && !has('clipboard')
  echohl WarningMsg
  echomsg 'Warning: Vim was built without clipboard support (+clipboard).'
  echohl None
endif

# Try to fix ghost characters on screen
# If it fails, increase to 200
set ttimeoutlen=50
