vim9script
def VisualSetSearch()
  var temp = getreg('"')
  normal! gvy
  var pattern = '\V' .. substitute(escape(getreg('"'), '\'), '\n', '\\n', 'g')
  setreg('/', pattern)
  setreg('@', temp)
enddef

vnoremap / :<C-u><ScriptCmd>VisualSetSearch()<cr>//<cr>
vnoremap ? :<C-u><ScriptCmd>VisualSetSearch()<cr>??<cr>
vnoremap <leader>/ :<C-u><ScriptCmd>VisualSetSearch()<cr>:%s/<C-r>///g<left><left>
