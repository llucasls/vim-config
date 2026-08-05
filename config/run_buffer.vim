vim9script
const interpreter_dict = {
  'vim': 'vim',
  'lua': 'lua',
  'lisp': 'emacs -x',
  'python': 'python3',
  'javascript': 'node',
  'php': 'php',
  'java': 'java',
  'coffee': 'coffee',
  'typescript': 'deno run --allow-all',
  'sql': 'mysql --table <',
  'mongodb': 'mongosh --quiet <',
  'sh': 'sh',
  'fish': 'fish',
  'r': 'Rscript',
  'plaintex': 'lualatex',
  'tex': 'lualatex',
  'c': 'exec-c',
  'make': 'make -f',
}

const expand_list = ['%', '#']

def GetInterpreter(): string
  var first_line = getline(1)
  var shebang_cmd = substitute(first_line, '^#!', '', '')
  var file_uses_shebang = shebang_cmd != '' && shebang_cmd !=# first_line

  if file_uses_shebang
    return shebang_cmd
  elseif interpreter_dict->has_key(&filetype)
    return interpreter_dict[&filetype]
  else
    echo 'Interpreter not found for filetype:' &filetype
  endif
  return ''
enddef

def SaveFile(files: list<string>): void
  var current_buffer = bufnr('')
  for file in files
    var buf = bufnr(file)
    if buf > 0 && getbufvar(buf, '&modifiable') && !getbufvar(buf, '&readonly')
      execute 'buffer' buf
      silent! w
      execute 'buffer' current_buffer
      return
    endif
  endfor
enddef

def SaveOpenFiles(files: list<string>): void
  var current_buffer = bufnr('')
  for file in files
    var buf = bufnr(file)
    if buf > 0 && getbufvar(buf, '&modifiable') && !getbufvar(buf, '&readonly')
      execute 'buffer' buf
      silent! w
    endif
  endfor
  execute 'buffer' current_buffer
enddef

def RunBuffer(): void
  var cmd = GetInterpreter()
  if cmd == ''
    return
  endif

  var file = expand('%::S')
  silent! w
  if &filetype ==# 'vim'
    execute 'source' file
  else
    echo trim(system(cmd .. ' ' .. file))
    if v:shell_error != 0
      echo 'shell returned ' .. v:shell_error
    endif
  endif
enddef

def RunBufferWithArgs(): void
  const InputInterrupt = ''
  var cmd = GetInterpreter()
  if cmd == ''
    return
  endif

  silent! w
  var prompt = printf('$ %s ', cmd)
  var user_input = input(prompt, '', 'file')

  if trim(user_input) !=# InputInterrupt
    echo "\n"
    var argv: list<string> = []
    for arg in user_input->split()
      if expand_list->index(arg) == -1
        argv += [arg]
      else
        argv += [expand(arg)]
      endif
    endfor

    if &filetype ==# 'vim'
      SaveOpenFiles(argv)
      for file in argv
        execute 'source' file
      endfor
    else
      SaveFile(argv)
      var arg_list = argv->join()
      var command = printf('%s %s', cmd, arg_list)
      echo trim(system(command))
      if v:shell_error != 0
        echo 'shell returned ' .. v:shell_error
      endif
    endif
  endif
enddef

# Map a key to run the current buffer
nnoremap <leader><leader> <ScriptCmd>RunBuffer()<cr>
nnoremap <leader><space> <ScriptCmd>RunBufferWithArgs()<cr>
