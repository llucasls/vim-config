let g:mapleader = ","

nnoremap <F2> :NERDTreeToggle <cr>
nnoremap <F3> :set relativenumber! <cr>
nnoremap <F4> :nohlsearch<cr>
nnoremap <F8> :e term://pulsemixer<cr>
nnoremap <F9> :w<cr> :!coffee -bp %<cr>
nnoremap <leader>m :w<cr> :!mongosh --quiet < %<cr>
" Select all the current file's content
nnoremap <leader>y :%yank+<cr>

nnoremap <leader>s :%substitute//g<left><left>

"Shift + Tab writes hard tab
inoremap <S-Tab> <C-V><Tab>
"Ctrl + Tab does inverse tab
inoremap <C-Tab> <C-d>

nnoremap <PageUp> :hide bprevious <cr>
nnoremap <PageDown> :hide bnext <cr>
nnoremap <Home> :hide bfirst <cr>
nnoremap <End> :hide blast <cr>
nnoremap <Del> :bdelete! <cr>
"nnoremap <Insert> :hide enew <cr>

"Remap the j, k, 0 and $ keys to gj, gk, g0 and g$ in normal mode
nmap j gj
nmap k gk
nmap 0 g0
nmap $ g$

inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap ' ''<left>
inoremap " ""<left>
