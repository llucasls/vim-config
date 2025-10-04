vim9script
if v:progname ==# 'vim'  # not vi
  if $TERM ==? 'linux' || $TERM =~? '^vt'
    $session_type = 'tty'
  else
    $session_type = 'gui'
  endif

  var vimdir = $MYVIMDIR->trim('/', 2)
  command -nargs=1 Source execute printf('source %s/%s', vimdir, <q-args>)
  command -nargs=1 Require execute printf('source %s/config/%s.vim', vimdir, <q-args>)

  Require term
  Require keybindings
  Require run_buffer
  Require search
  Require help
  Require autocmd
  Require options
  Require plugins
endif
