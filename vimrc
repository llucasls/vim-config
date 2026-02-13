vim9script
if v:progname ==# 'vim'  # not vi
  const session_defined: bool = environ()->has_key('session_type')
  if !session_defined && ($TERM ==? 'linux' || $TERM =~? '^vt')
    $session_type = 'tty'
  elseif !session_defined
    $session_type = 'gui'
  endif

  if !$MYVIMDIR
    var path_list = $MYVIMRC->split('/')
    $MYVIMDIR = path_list->slice(0, path_list->len() - 1)->join('/')
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

  if filereadable($'{vimdir}/local.vim')
    Source local.vim
  endif
endif
