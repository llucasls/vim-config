vim9script
# use Help command to open help pages in a new buffer
command -bar -nargs=? -complete=help HelpCurwin call HelpCurwin(<q-args>)

var did_open_help = v:false

def HelpCurwin(subject: string): void
  var mods = 'silent noautocmd keepalt'
  if !did_open_help
    execute mods 'help'
    execute mods 'helpclose'
    did_open_help = v:true
  endif
  if !empty(getcompletion(subject, 'help'))
    execute mods 'edit' &helpfile
    set buftype=help
  endif
  execute 'help' subject
  bdelete help.txt
  set buflisted
  set bufhidden=delete
  #return 'help ' .. subject
enddef
