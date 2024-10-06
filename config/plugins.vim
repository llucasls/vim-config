" let g:polyglot_disabled = ['sensible']
call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'w0rp/ale'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'arcticicestudio/nord-vim'
Plug 'garbas/vim-snipmate'
"Plug 'morhetz/gruvbox'
"Plug 'liuchengxu/space-vim-dark'
"Plug 'raphamorim/lucario'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'diepm/vim-rest-console'
Plug 'sheerun/vim-polyglot'
Plug 'vim-scripts/info.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'flazz/vim-colorschemes'
call plug#end()

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

let g:vrc_horizontal_split=1

let g:snipMate = { 'snippet_version' : 1 }

let g:vrc_curl_opts = { '-v': '', }

let g:gruvbox_italic=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
