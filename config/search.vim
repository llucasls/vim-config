vim9script
def VSetSearch()
  var temp = getreg('"')
  normal! gvy
  var pattern = '\V' .. substitute(escape(getreg('"'), '\'), '\n', '\\n', 'g')
  setreg('/', pattern)
  setreg('@', temp)
enddef

command! VSetSearch call VSetSearch()

vnoremap / :<C-u>VSetSearch<cr>//<cr>
vnoremap ? :<C-u>VSetSearch<cr>??<cr>
vnoremap <leader>/ :<C-u>VSetSearch<cr>:%s/<C-r>///g<left><left>
