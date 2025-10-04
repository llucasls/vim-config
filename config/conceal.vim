vim9script
def ConcealClassNames(conceal_char: string = '…'): void
  var opts: dict<any> = {conceal: conceal_char}
  var id: number

  if has_key(g:, 'tailwind_conceal_words')
    var num: number = g:tailwind_conceal_words
    matchadd('Conceal', $'className="\zs\([^" ]\+ \)\{{{num},}}[^"]\+\ze"', 10, -1, opts)
    matchadd('Conceal', $'className=''\zs\([^'' ]\+ \)\{{{num},}}[^'']\+\ze''', 10, -1, opts)
  endif

  if has_key(g:, 'tailwind_conceal_chars')
    var num: number = g:tailwind_conceal_chars
    matchadd('Conceal', $'className="\zs\([^"]\{{{num},}}\)\ze"', 10, -1, opts)
    matchadd('Conceal', $'className=''\zs\([^'']\{{{num},}}\)\ze''', 10, -1, opts)
  endif
enddef

augroup conceal_tailwind
  autocmd!
  autocmd FileType javascriptreact call ConcealClassNames()
  #autocmd CmdlineLeave javascriptreact call ConcealClassNames()
augroup END

# TODO: deal with match numbers and events
g:tailwind_conceal_chars = 30
g:tailwind_conceal_words = 2
