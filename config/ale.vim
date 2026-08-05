vim9script
import 'oxlint.vim'
import 'find.vim'

oxlint.SetupOxlint('json')

g:ale_javascript_eslint_suppress_missing_config = 1

g:ale_linters = {}
g:ale_linters['javascript'] = []
g:ale_linters['javascriptreact'] = []
g:ale_linters['typescript'] = []
g:ale_linters['typescriptreact'] = []

const js_linter_files = {
    eslint: [
        'eslint.config.js',
        'eslint.config.cjs',
        'eslint.config.mjs',
        '.eslintrc.js',
        '.eslintrc.json',
    ],
    oxlint: ['.oxlintrc.json'],
    biome: ['biome.json', 'biome.jsonc'],
    deno: ['deno.json', 'deno.jsonc'],
    tsserver: ['jsconfig.json'],
}

const ts_linter_files = {
    eslint: [
        'eslint.config.js',
        'eslint.config.cjs',
        'eslint.config.mjs',
        'eslint.config.ts',
        'eslint.config.cts',
        'eslint.config.mts',
        '.eslintrc.json',
    ],
    oxlint: ['.oxlintrc.json', 'oxlint.config.ts'],
    biome: ['biome.json', 'biome.jsonc'],
    deno: ['deno.json', 'deno.jsonc'],
    tsserver: ['tsconfig.json'],
}

const project_directory = find.Directory.new(find.FindConfig(['.git'], $HOME))

for [linter, file_list] in js_linter_files->items()
    if project_directory.HasOneOf(file_list)
        g:ale_linters['javascript']->add(linter)
        g:ale_linters['javascriptreact']->add(linter)
    endif
endfor
for [linter, file_list] in ts_linter_files->items()
    if project_directory.HasOneOf(file_list)
        g:ale_linters['typescript']->add(linter)
        g:ale_linters['typescriptreact']->add(linter)
    endif
endfor

# Ensure deno and tsserver aren't used simultaneously.
# Deno takes precedence in such cases. If the deno executable is not found,
# leave tsserver untouched.
var has_deno = false
var tsserver_index = -1
var i = 0

const filetypes = [
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
]
for filetype in filetypes
    for linter in g:ale_linters[filetype]
        if linter ==# 'deno'
            has_deno = true
        elseif linter ==# 'tsserver'
            tsserver_index = i
        endif
        i += 1
    endfor
    if has_deno && !executable('deno')
        echohl WarningMsg
        echomsg 'Deno executable not found in $PATH'
        echohl None
        break
    elseif has_deno && tsserver_index != -1
        g:ale_linters[filetype]->remove(tsserver_index)
    endif
    has_deno = false
    tsserver_index = -1
    i = 0
endfor

augroup AleDetailTweaks
    autocmd!
    autocmd FileType ale-preview setlocal listchars-=trail:+
augroup END

nnoremap <leader>d <Plug>(ale_detail)
