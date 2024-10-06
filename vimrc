let s:vimdir = $MYVIMRC->split("/", v:true)[:-2]->join("/")
command -nargs=1 Source execute printf('source %s/%s', s:vimdir, <q-args>)
command -nargs=1 Require execute printf('source %s/config/%s.vim', s:vimdir, <q-args>)

Require plugins
Require options
Require keybindings
Require run_buffer
Require search
Require help
Require autocmd
Require term
