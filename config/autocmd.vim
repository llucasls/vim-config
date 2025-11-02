vim9script
# Function to turn off caps lock
# https://vi.stackexchange.com/questions/376/can-vim-automatically-turn-off-capslock-when-returning-to-normal-mode/11506
# https://vi.stackexchange.com/users/11493/avian-y
const pattern = '00: Caps Lock:\s\+\zs\(on\|off\)\ze'

def TurnOffCaps()
  if $session_type ==# 'tty' || !executable('xset') || !executable('xdotool')
    return
  endif

  var caps_state = matchstr(system('xset -q'), pattern)
  if caps_state == 'on'
    silent! execute ':!xdotool key Caps_Lock'
  endif
enddef

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
  autocmd VimResized * SetScrolloff('local')
  autocmd WinResized * SetScrolloff('local')
  autocmd WinNew * SetScrolloff('local')
  autocmd WinEnter * SetScrolloff('local')
augroup END

if $session_type ==# 'gui'
  augroup terminal
    autocmd!
    autocmd VimEnter * normal! i
    autocmd VimLeave * :!printf '\033[2 q'
  augroup END
endif
