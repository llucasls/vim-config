vim9script
export def FindConfig(file_list: list<string>, stop_at: string = ''): string
    const directories = getcwd()->split('/')
    var n = len(directories)

    var files: list<string>
    var path: string
    while n > 0
        path = $"/{directories->slice(0, n)->join('/')}"
        if stop_at !=# '' && path ==# stop_at
            return path
        endif
        files = readdir(path, (name) => file_list->index(name) != -1)
        if len(files) > 0
            return path
        endif
        n -= 1
    endwhile
    return '/'
enddef
