vim9script
# set config variables before loading plugins
g:polyglot_disabled = ['php']

g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

g:vrc_horizontal_split = 1

g:snipMate = { 'snippet_version': 1 }

g:vrc_curl_opts = { '-v': '', }

g:gruvbox_italic = 1

g:airline#extensions#tabline#enabled = 1
g:airline#extensions#tabline#alt_sep = 0
g:airline#extensions#tabline#left_sep = ' '
g:airline#extensions#tabline#left_alt_sep = ''
g:airline#extensions#tabline#formatter = 'unique_tail'

# load plugins
plug#begin()

Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'w0rp/ale'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'https://github.com/EvitanRelta/vim-colorschemes'

if $session_type ==# 'gui' && &term !~# 'xterm'
  Plug 'ryanoasis/vim-devicons'
endif

plug#end()

# set colorscheme after plugin is loaded
# read &term directly so it works on ssh
if &term ==? 'linux' || &term =~? '^vt'
  colorscheme atom
else
  colorscheme onedark
endif
