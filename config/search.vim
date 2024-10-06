function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap / :<C-u>call <SID>VSetSearch()<cr>//<cr>
vnoremap ? :<C-u>call <SID>VSetSearch()<cr>??<cr>
vnoremap <leader>/ :<C-u>call <SID>VSetSearch()<cr>:%s/<C-r>///g<left><left>
