vim9script
var vimdir = $MYVIMDIR->trim('/', 2)
command -nargs=1 Source execute printf('source %s/%s', vimdir, <q-args>)
command -nargs=1 Require execute printf('source %s/config/%s.vim', vimdir, <q-args>)

Require plugins
Require options
Require term
Require keybindings
Require run_buffer
Require search
Require help
Require type
Require autocmd
