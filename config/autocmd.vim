" Function to turn off caps lock
" https://vi.stackexchange.com/questions/376/can-vim-automatically-turn-off-capslock-when-returning-to-normal-mode/11506
" https://vi.stackexchange.com/users/11493/avian-y
function s:TurnOffCaps()
    let capsState = matchstr(system('xset -q'), '00: Caps Lock:\s\+\zs\(on\|off\)\ze')
    if capsState == 'on'
        silent! execute ':!xdotool key Caps_Lock'
    endif
endfunction

function s:SetScrolloff()
    let &scrolloff = printf('%.f', round(winheight(0) / 3.0))
endfunction

augroup auto_commands
  autocmd!
  autocmd InsertLeave * call s:TurnOffCaps()
  autocmd VimResized * call s:SetScrolloff()
augroup END
