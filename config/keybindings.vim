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

# Remap the j, k, 0 and $ keys to gj, gk, g0 and g$ in normal mode
# The motions don't change when preceded by a count
nnoremap <expr> j v:count != 0 ? 'j' : 'gj'
nnoremap <expr> k v:count != 0 ? 'k' : 'gk'
nnoremap <expr> 0 v:count != 0 ? '0' : 'g0'
nnoremap <expr> $ v:count != 0 ? '$' : 'g$'

inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap ' ''<left>
inoremap " ""<left>
