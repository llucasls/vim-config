vim9script
g:mapleader = ","

def GoToStart(): void
  const prev_col = getpos('.')[2]
  execute 'normal! g0'
  const next_col = getpos('.')[2]
  if prev_col == next_col
    execute 'normal! 0'
  endif
enddef

def GoToEnd(): void
  const prev_col = getpos('.')[2]
  execute 'normal! g$'
  const next_col = getpos('.')[2]
  if prev_col == next_col
    execute 'normal! $'
  endif
enddef

def GoToPattern(pattern: string, count: number, backward = false): void
  const flags = backward ? 'bnW' : 'nW'
  const [line, column] = searchpos(pattern, flags, 0, 0)
  if count > 0 && line != 0
    cursor(line, column)
    GoToPattern(pattern, count - 1, backward)
  endif
enddef

def WriteSingleQuotes(): void
  const [bufnum, lnum, col, off] = getcharpos('.')
  const text = getline(lnum)
  const is_not_quote = text->strcharpart(col - 1, 1, 1) != "'"

  if is_not_quote && col > 2 && text->strcharpart(col - 3, 2, 1) == "''"
    const head = text->strcharpart(0, col - 2)
    const tail = text->strcharpart(col - 2)
    setline(lnum, $"{head}''''{tail}")
  elseif is_not_quote
    const head = text->strcharpart(0, col - 1)
    const tail = text->strcharpart(col - 1)
    setline(lnum, $"{head}''{tail}")
  endif

  setcharpos('.', [bufnum, lnum, col + 1, off])
enddef

def WriteDoubleQuotes(): void
  const [bufnum, lnum, col, off] = getcharpos('.')
  const text = getline(lnum)
  const is_not_quote = text->strcharpart(col - 1, 1, 1) != '"'

  if is_not_quote && col > 2 && text->strcharpart(col - 3, 2, 1) == '""'
    const head = text->strcharpart(0, col - 2)
    const tail = text->strcharpart(col - 2)
    setline(lnum, $'{head}""""{tail}')
  elseif is_not_quote
    const head = text->strcharpart(0, col - 1)
    const tail = text->strcharpart(col - 1)
    setline(lnum, $'{head}""{tail}')
  endif

  setcharpos('.', [bufnum, lnum, col + 1, off])
enddef

def WriteClosingParenthesis(): void
  const [bufnum, lnum, col, off] = getcharpos('.')
  const text = getline(lnum)

  if text->strcharpart(col - 1, 1) != ')'
    const head = text->strcharpart(0, col - 1)
    const tail = text->strcharpart(col - 1)
    setline(lnum, $'{head}){tail}')
  endif

  setcharpos('.', [bufnum, lnum, col + 1, off])
enddef

def WriteClosingBrackets(): void
  const [bufnum, lnum, col, off] = getcharpos('.')
  const text = getline(lnum)

  if text->strcharpart(col - 1, 1) != ']'
    const head = text->strcharpart(0, col - 1)
    const tail = text->strcharpart(col - 1)
    setline(lnum, $'{head}]{tail}')
  endif

  setcharpos('.', [bufnum, lnum, col + 1, off])
enddef

def WriteClosingBraces(): void
  const [bufnum, lnum, col, off] = getcharpos('.')
  const text = getline(lnum)

  if text->strcharpart(col - 1, 1) != '}'
    const head = text->strcharpart(0, col - 1)
    const tail = text->strcharpart(col - 1)
    setline(lnum, $'{head}}}{tail}')
  endif

  setcharpos('.', [bufnum, lnum, col + 1, off])
enddef

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

if &term =~# 'xterm'
  nnoremap <silent> <M-k> :PreviousBuffer <cr>
  nnoremap <silent> <M-j> :NextBuffer <cr>
  nnoremap <silent> <M-h> :hide bfirst! <cr>
  nnoremap <silent> <M-l> :hide blast! <cr>
  nnoremap <silent> <C-d> :bdelete! <cr>
  nnoremap <M-u> <ScriptCmd>GoToPattern('\%(\u\)\@<!\u\|\u\ze\l', v:count1)<cr>
  nnoremap <M-o> <ScriptCmd>GoToPattern('\l', v:count1)<cr>
  nnoremap <M-0> <ScriptCmd>GoToPattern('\d', v:count1)<cr>
  nnoremap <M--> <ScriptCmd>GoToPattern('[\-_]', v:count1)<cr>
  nnoremap <M-U> <ScriptCmd>GoToPattern('\%(\u\)\@<!\u\|\u\ze\l', v:count1, true)<cr>
  nnoremap <M-O> <ScriptCmd>GoToPattern('\l', v:count1, true)<cr>
  nnoremap <M-)> <ScriptCmd>GoToPattern('\d', v:count1, true)<cr>
  nnoremap <M-_> <ScriptCmd>GoToPattern('[\-_]', v:count1, true)<cr>
else
  nnoremap <PageUp> :PreviousBuffer <cr>
  nnoremap <PageDown> :NextBuffer <cr>
  nnoremap <Home> :hide bfirst! <cr>
  nnoremap <End> :hide blast! <cr>
  nnoremap <Del> :bdelete! <cr>
  nnoremap <esc>u <ScriptCmd>GoToPattern('\%(\u\)\@<!\u\\|\u\ze\%(\l\\|\d\\|[\-_]\)', v:count1)<cr>
  nnoremap <esc>l <ScriptCmd>GoToPattern('\l', v:count1)<cr>
  nnoremap <esc>0 <ScriptCmd>GoToPattern('\d', v:count1)<cr>
  nnoremap <esc>- <ScriptCmd>GoToPattern('[\-_]', v:count1)<cr>
  nnoremap <esc>U <ScriptCmd>GoToPattern('\%(\u\)\@<!\u\\|\u\ze\%(\l\\|\d\\|[\-_]\)', v:count1, true)<cr>
  nnoremap <esc>L <ScriptCmd>GoToPattern('\l', v:count1, true)<cr>
  nnoremap <esc>) <ScriptCmd>GoToPattern('\d', v:count1, true)<cr>
  nnoremap <esc>_ <ScriptCmd>GoToPattern('[\-_]', v:count1, true)<cr>
endif

# Remap the j, k, 0 and $ keys to move between visual lines.
# The up and down motions use logical lines when preceded by a count.
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
# Go to start/end of visual line. If the cursor is already at the
# start or end, use logical line motions instead.
nnoremap 0 <ScriptCmd>GoToStart()<cr>
nnoremap $ <ScriptCmd>GoToEnd()<cr>

inoremap ( ()<left>
inoremap ) <ScriptCmd>WriteClosingParenthesis()<cr>
inoremap [ []<left>
inoremap ] <ScriptCmd>WriteClosingBrackets()<cr>
inoremap { {}<left>
inoremap } <ScriptCmd>WriteClosingBraces()<cr>
inoremap ' <ScriptCmd>WriteSingleQuotes()<cr>
inoremap " <ScriptCmd>WriteDoubleQuotes()<cr>
