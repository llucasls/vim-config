vim9script
const pattern = '00: Caps Lock:\s\+\zs\(on\|off\)\ze'

if $session_type ==# 'gui' && executable('xset') && executable('xdotool')
  def TurnOffCaps(): void
    const caps_state: string = matchstr(system(['xset', '-q']), pattern)
    if caps_state ==? 'on'
      system(['xdotool', 'key', 'Caps_Lock'])
    endif
  enddef
elseif $session_type ==# 'tty' && executable('xset') && executable('setleds')
  def TurnOffCaps(): void
    const caps_state: string = matchstr(system(['xset', '-q']), pattern)
    if caps_state ==? 'on'
      system(['setleds', '-caps'])
    endif
  enddef
else
  def TurnOffCaps(): void
  enddef
endif
defcompile TurnOffCaps

def SetScrolloff(scope: string = ''): void
  if scope ==# 'local'
    &l:scrolloff = float2nr(round(winheight(0) / 3.0))
  elseif scope ==# 'global'
    &g:scrolloff = float2nr(round(winheight(0) / 3.0))
  else
    &scrolloff = float2nr(round(winheight(0) / 3.0))
  endif
enddef

augroup auto_commands
  autocmd!
  autocmd InsertLeave * TurnOffCaps()
  autocmd CmdlineLeave * TurnOffCaps()
  autocmd VimResized * SetScrolloff('local')
  autocmd WinResized * SetScrolloff('local')
  autocmd WinNew * SetScrolloff('local')
  autocmd WinEnter * SetScrolloff('local')
  autocmd FileType markdown setlocal conceallevel=0
  autocmd FileType diff,git,fugitive setlocal listchars-=trail:+
augroup END

if $session_type ==# 'gui'
  augroup terminal
    autocmd!
    autocmd VimEnter * normal! i
    autocmd VimLeave * :silent !printf '\033[2 q'
  augroup END
endif
