vim9script
export def FindConfig(file_list: list<string>, stop_at: string = ''): string
    const directories = getcwd()->split('/')
    var n = len(directories)

    var files: list<string>
    var path: string
    while n > 0
        path = $"/{directories->slice(0, n)->join('/')}"

        # stop directory was reached
        if stop_at !=# '' && path ==# stop_at
            return path
        endif
        files = readdir(path, (name) => file_list->index(name) != -1)

        # at least one file is found
        if len(files) > 0
            return path
        endif
        n -= 1
    endwhile
    return '/'
enddef

export class Directory
    final path: string

    def new(path: string)
        this.path = path
    enddef

    def HasFile(file_name: string): bool
        for file in readdir(this.path)
            if file ==# file_name
                return true
            endif
        endfor
        return false
    enddef

    def HasOneOf(file_list: list<string>): bool
        final files = {}
        for file in readdir(this.path)
            files[file] = true
        endfor
        for file in file_list
            if files->get(file, false)
                return true
            endif
        endfor
        return false
    enddef
endclass
