vim9script
import 'find.vim'

const FindConfig = find.FindConfig

class OxLintData
    var col: number
    var length: number
    var end_col: number
    var line: number
    var offset: number

    var code: string
    var msg: string
    var help_msg: string
    var filename: string
    var type: string

    def new(data: dict<any>)
        const labels: list<dict<any>> = data->get('labels', [])
        const label: dict<any> = labels->get(0)
        const span: dict<any> = label->get('span', {})

        this.col = span->get('column')
        this.length = span->get('length')
        this.end_col = this.col + this.length
        this.line = span->get('line')
        this.offset = span->get('offset')

        this.code = data->get('code', '')
        this.msg = data->get('message', '')
        this.help_msg = data->get('help', '')
        this.filename = data->get('filename', '')
        this.type = toupper(data->get('severity', 'E')[0])
    enddef

    def Linter(buffer: number = 0): dict<any>
        final output: dict<any> = {
            text: this.msg,
            lnum: this.line,
            col: this.col,
            end_col: this.end_col,
            filename: this.filename,
            vcol: 0,
            type: this.type,
            code: this.code,
            detail: this.Detail(),
        }

        if buffer != 0
            output['bufnr'] = buffer
        endif

        return output
    enddef

    def Detail(): string
        const name: string = this.filename
        const num_size: number = float2nr(floor(log10(this.line + 1))) + 1

        const file_content: list<string> = readfile(name, '', this.line + 1)
        const lines: list<string> = file_content->slice(-3)

        const current_line = getline(this.line)
        const lines_read = getline(this.line - 1, this.line + 1)
        const i = lines_read->index(current_line)

        const used_lines: list<any> = [
            (i > 0) ? lines_read[0]->substitute("\t", '    ', 'g') : "\1",
            current_line->substitute("\t", '    ', 'g'),
            lines_read->get(i + 1, "\1")->substitute("\t", '    ', 'g'),
        ]

        const no_empty_file = 'eslint-plugin-unicorn(no-empty-file)'

        if this.code ==# no_empty_file && $session_type ==# 'gui'
            return this._DetailEmptyGUI()
        elseif this.code ==# no_empty_file
            return this._DetailEmptyTTY()
        elseif $session_type ==# 'gui'
            return this._DetailGUI(name, num_size, used_lines)
        else
            return this._DetailTTY(name, num_size, used_lines)
        endif
    enddef

    def _DetailEmptyGUI(): string
        const end: number = line('$')
        const num_size: number = float2nr(floor(log10(end + 1))) + 1

        const first_line: string = getline(1)->substitute("\t", '    ', 'g')
        const last_line: string = getline(end)->substitute("\t", '    ', 'g')
        const file_is_empty: bool = first_line == '' && end == 1

        const filename = this.filename
        const icon = this.type ==# 'W' ? '⚠' : '×'

        final output: list<string> = [
            printf('  %s  %s: %s', icon, this.code, this.msg),
            printf(' %*s ╭─[%s:%d:%d]', num_size, '', filename, this.line, this.col),
            printf(' %*s ╰────', num_size, ''),
        ]
        if this.help_msg != ''
            output->add(printf('  help: %s', this.help_msg))
        endif

        if file_is_empty
            return output->join("\n")
        elseif end == 1
            const content_lines: list<string> = [
                printf(' 1 │  %s', first_line),
                printf('   · %s', repeat('─', len(first_line) + 1)),
            ]
            output->extend(content_lines, 2)
        elseif end == 2
            const content_lines: list<string> = [
                printf(' 1 │ ╭─▶  %s', first_line),
                printf(' 2 │ ╰─▶  %s', last_line),
            ]
            output->extend(content_lines, 2)
        elseif end == 3
            final content_lines: list<string> = [
                printf(' 1 │ ╭─▶  %s', first_line),
                printf(' 2 │ │    %s', getline(2)),
                printf(' 3 │ ╰─▶  %s', last_line),
            ]
            output->extend(content_lines, 2)
        else
            final content_lines: list<string> = [
                printf(' %*d │ ╭─▶  %s', num_size, 1, first_line),
                printf(' %*s … │ ', num_size, ''),
                printf(' %*d │ ╰─▶  %s', num_size, end, last_line),
            ]
            output->extend(content_lines, 2)
        endif

        return output->join("\n")
    enddef

    def _DetailEmptyTTY(): string
        const end: number = line('$')
        const num_size: number = float2nr(floor(log10(end + 1))) + 1

        const first_line: string = getline(1)->substitute("\t", '    ', 'g')
        const last_line: string = getline(end)->substitute("\t", '    ', 'g')
        const file_is_empty: bool = first_line == '' && end == 1

        const filename = this.filename
        const icon = this.type ==# 'W' ? '!' : 'x'

        final output: list<string> = [
            printf('  %s %s: %s', icon, this.code, this.msg),
            printf(' %*s ,-[%s:%d:%d]', num_size, '', filename, this.line, this.col),
            printf(' %*s `----', num_size, ''),
        ]
        if this.help_msg != ''
            output->add(printf('  help: %s', this.help_msg))
        endif

        if file_is_empty
            return output->join("\n")
        elseif end == 1
            const content_lines: list<string> = [
                printf(' 1 | %s', first_line),
                printf('   : %s', repeat('^', len(first_line) + 1)),
            ]
            output->extend(content_lines, 2)
        elseif end == 2
            const content_lines: list<string> = [
                printf(' 1 | ,-> %s', first_line),
                printf(' 2 | `-> %s', last_line),
            ]
            output->extend(content_lines, 2)
        elseif end == 3
            final content_lines: list<string> = [
                printf(' 1 | ,-> %s', first_line),
                printf(' 2 | |   %s', getline(2)),
                printf(' 3 | `-> %s', last_line),
            ]
            output->extend(content_lines, 2)
        else
            final content_lines: list<string> = [
                printf(' %*d  |  ,-> %s', num_size, 1, first_line),
                printf(' %*s ... | ', num_size, ''),
                printf(' %*d  |  `-> %s', num_size, end, last_line),
            ]
            output[1] = $' {output[1]}'
            output[2] = $' {output[2]}'
            output->extend(content_lines, 2)
        endif

        return output->join("\n")
    enddef

    def _DetailGUI(filename: string, num_size: number, lines: list<string>): string
        const [prev_line, curr_line, next_line] = lines
        const icon = this.type ==# 'W' ? '⚠' : '×'

        final output: list<string> = [
            printf('  %s  %s: %s', icon, this.code, this.msg),
            printf(' %*s ╭─[%s:%d:%d]', num_size, '', filename, this.line, this.col),
            printf(' %*s ╰────', num_size, ''),
        ]

        if this.help_msg != ''
            output->add(printf('  help: %s', this.help_msg))
        endif

        final content_lines: list<string> = []

        if prev_line != "\1"
            content_lines->add(printf(
                ' %*d │ %s', num_size, this.line - 1, prev_line
            ))
        endif
        content_lines->add(printf(
            ' %*d │ %s', num_size, this.line, curr_line
        ))
        content_lines->add(printf(
            ' %*s ·%*s%s', num_size, '', this.col, '', repeat('─', this.length)
        ))
        if next_line != "\1"
            content_lines->add(printf(
                ' %*d │ %s', num_size, this.line + 1, next_line
            ))
        endif

        output->extend(content_lines, 2)

        return output->join("\n")
    enddef

    def _DetailTTY(filename: string, num_size: number, lines: list<string>): string
        const [prev_line, curr_line, next_line] = lines
        const icon = this.type ==# 'W' ? '!' : 'x'

        final output: list<string> = [
            printf('  %s %s: %s', icon, this.code, this.msg),
            printf(' %*s ,-[%s:%d:%d]', num_size, '', filename, this.line, this.col),
            printf(' %*s `----', num_size, ''),
        ]

        if this.help_msg != ''
            output->add(printf('  help: %s', this.help_msg))
        endif

        final content_lines: list<string> = []

        if prev_line != "\1"
            content_lines->add(printf(
                ' %*d | %s', num_size, this.line - 1, prev_line
            ))
        endif
        content_lines->add(printf(
            ' %*d | %s', num_size, this.line, curr_line
        ))
        content_lines->add(printf(
            ' %*s :%*s%s', num_size, '', this.col, '', repeat('─', this.length)
        ))
        if next_line != "\1"
            content_lines->add(printf(
                ' %*d | %s', num_size, this.line + 1, next_line
            ))
        endif

        output->extend(content_lines, 2)

        return output->join("\n")
    enddef
endclass

export def RunOxlint(buffer: number, lines: list<string>): list<dict<any>>
    final output: list<dict<any>> = []

    const raw = lines->join('')
    if raw == ''
        return []
    endif

    const decoded = json_decode(raw)

    if type(decoded) != v:t_dict || !has_key(decoded, 'diagnostics')
        return []
    endif

    var labels: list<dict<any>>
    var label: dict<any>

    for item in decoded['diagnostics']
        labels = item->get('labels', [])
        label = labels->get(0)
        if !label
            continue
        endif
        const data = OxLintData.new(item)
        output->add(data.Linter(buffer))
    endfor

    return output
enddef

const home = environ()->get('HOME', '/')
const oxlint_files = ['.git', '.oxlintrc.json']
for filetype in ['javascript', 'typescript']
    ale#linter#Define(filetype, {
        name: 'oxlint_lsp',
        executable: 'oxlint',
        command: 'oxlint --lsp',
        read_buffer: 1,
        lsp: 'stdio',
        project_root: (_buf) => FindConfig(oxlint_files, home),
    })

    ale#linter#Define(filetype, {
        name: 'oxlint_json',
        executable: 'oxlint',
        command: 'oxlint --format=json %s',
        read_buffer: 0,
        callback: RunOxlint,
        project_root: (_buf) => FindConfig(oxlint_files, home),
    })
endfor

export def SetupOxlint(variant: string): void
    for filetype in ['javascript', 'typescript']
        if variant ==# 'lsp'
            ale#linter#Define(filetype, {
                name: 'oxlint',
                executable: get(g:, 'oxlint_executable', 'oxlint'),
                command: '%e --lsp',
                read_buffer: 1,
                lsp: 'stdio',
                project_root: (_buf) => FindConfig(oxlint_files, home),
            })
        elseif variant ==# 'json'
            ale#linter#Define(filetype, {
                name: 'oxlint',
                executable: get(g:, 'oxlint_executable', 'oxlint'),
                command: '%e --format=json %s',
                read_buffer: 0,
                callback: RunOxlint,
                project_root: (_buf) => FindConfig(oxlint_files, home),
            })
        endif
    endfor
enddef
