const s:interpreter_dict = {
  \ 'vim': 'vim',
  \ 'lua': 'lua',
  \ 'lisp': 'emacs -x',
  \ 'python': 'python3',
  \ 'javascript': 'node',
  \ 'php': 'php',
  \ 'java': 'java',
  \ 'coffee': 'coffee',
  \ 'typescript': 'ts-node',
  \ 'sql': 'mysql --table <',
  \ 'mongodb': 'mongosh --quiet <',
  \ 'sh': 'sh',
  \ 'fish': 'fish',
  \ 'r': 'Rscript',
  \ 'plaintex': 'lualatex',
  \ 'tex': 'lualatex',
  \ 'c': 'exec-c',
  \ 'make': 'make -f',
  \ }

const s:expand_list = ['%', '#']

function! GetInterpreter()
  let first_line = getline(1)
  let shebang_cmd = substitute(first_line, '^#!', '', '')
  let file_uses_shebang = shebang_cmd != '' && shebang_cmd !=# first_line

  if file_uses_shebang
    return shebang_cmd
  elseif s:interpreter_dict->has_key(&filetype)
    return s:interpreter_dict[&filetype]
  else
    echo "Interpreter not found for filetype:" &filetype
  endif
endfunction

" Define a function to execute the current buffer
function! RunBuffer()
  let cmd = GetInterpreter()

  let file = expand('%')
  let save_cmd = 'silent! wa'
  if &filetype ==# 'vim'
    let run_cmd = 'source ' . file
  else
    let run_cmd = '!' . cmd . ' ' . file
  endif
  execute save_cmd | execute run_cmd
endfunction

function! RunBufferWithArgs()
  const l:InputInterrupt = ''
  let cmd = GetInterpreter()
  let prompt = printf('$ %s ', cmd)
  let l:result = input(prompt)

  if l:result !=# l:InputInterrupt
    echo "\n"
    let l:args = []
    for l:arg in l:result->split()
      if s:expand_list->index(l:arg) == -1
        let l:args += [l:arg]
      else
        let l:args += [expand(l:arg)]
      endif
    endfor

    let l:result = l:args->join()
    let l:command = printf('%s %s', cmd, l:result)
    let l:output = systemlist(l:command)
    for line in l:output
      echo line
    endfor
  endif
endfunction

" Map a key to run the current buffer
nnoremap <leader><leader> :w<cr>:call RunBuffer()<cr>
nnoremap <leader><space> :w<cr>:call RunBufferWithArgs()<cr>
