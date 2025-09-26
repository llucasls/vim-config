vim9script
# g:polyglot_disabled = ['sensible']

plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'w0rp/ale'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
#Plug 'arcticicestudio/nord-vim'
Plug 'garbas/vim-snipmate'
#Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'ryanoasis/vim-devicons'
#Plug 'flazz/vim-colorschemes'
Plug 'https://github.com/EvitanRelta/vim-colorschemes'
plug#end()

g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

g:vrc_horizontal_split = 1

g:snipMate = { 'snippet_version': 1 }

g:vrc_curl_opts = { '-v': '', }

g:gruvbox_italic = 1
g:airline#extensions#tabline#enabled = 1
g:airline#extensions#tabline#left_sep = ' '
g:airline#extensions#tabline#left_alt_sep = '|'
g:airline#extensions#tabline#formatter = 'unique_tail'
