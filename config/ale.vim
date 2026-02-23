vim9script
import 'oxlint.vim'

oxlint.SetupOxlint('json')

g:ale_javascript_eslint_suppress_missing_config = 1
g:ale_linters = {
    javascript: ['oxlint'],
    javascriptreact: ['oxlint'],
    typescript: ['oxlint', 'tsserver'],
    typescriptreact: ['oxlint', 'tsserver'],
}

augroup AleDetailTweaks
    autocmd!
    autocmd FileType ale-preview setlocal listchars-=trail:+
augroup END

nnoremap <leader>d <Plug>(ale_detail)
