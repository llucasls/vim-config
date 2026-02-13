vim9script
g:mapleader = ","

nnoremap <F2> :NERDTreeToggle <cr>
nnoremap <F3> :set relativenumber! <cr>
nnoremap <F4> :nohlsearch<cr>
# Select all the current file's content
nnoremap <leader>y :%yank+<cr>
nnoremap Y y$

nnoremap <leader>s :%substitute//g<left><left>
nnoremap <leader>; :vim9<space>

# Shift + Tab writes hard tab
inoremap <S-Tab> <C-V><Tab>
# Ctrl + Tab does inverse tab
inoremap <C-Tab> <C-d>

command -nargs=0 -range PreviousBuffer execute 'hide bprevious!' v:count1
command -nargs=0 -range NextBuffer execute 'hide bnext!' v:count1

nnoremap <PageUp> :PreviousBuffer <cr>
nnoremap <PageDown> :NextBuffer <cr>
nnoremap <Home> :hide bfirst! <cr>
nnoremap <End> :hide blast! <cr>
nnoremap <Del> :bdelete! <cr>
#nnoremap <Insert> :hide enew <cr>

#Remap the j, k, 0 and $ keys to gj, gk, g0 and g$ in normal mode
nmap j gj
nmap k gk
nmap 0 g0
nmap $ g$

inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap ' ''<left>
inoremap " ""<left>
