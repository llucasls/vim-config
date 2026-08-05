vim9script

# void elements:

# area
# base
# br
# col
# embed
# hr
# img
# input
# link
# meta
# param
# source
# track
# wbr

class XMLElement
  const selector: string
  var tag_type: string

  def new(input_str: string)
    if input_str == '' || input_str == '/' || input_str == '//'
      throw 'invalid selector'
    elseif input_str[0] == '/' && input_str[-1] == '/'
      this.selector = input_str[1:-2]
      this.tag_type = 'pair'
    elseif input_str[0] == '/'
      this.selector = input_str[1:]
      this.tag_type = 'closing'
    elseif input_str[-1] == '/'
      this.selector = input_str[:-2]
      this.tag_type = 'self-closing'
    else
      this.selector = input_str
      this.tag_type = 'opening'
    endif
  enddef

  def empty(): bool
    return false  # always false
  enddef

  def len(): number
    return 0
  enddef

  def string(): string
    return ''
  enddef

  def ParseTag(): void
    const selector = this.selector

    var tag_name = ''
    var id = ''
    var classes: list<string> = []
    var attrs: list<string> = []

    var i = 0
    while i < len(selector)
      var c = selector[i]

      if c == '#'
        i += 1
        var start = i
        while i < len(selector) && selector[i] =~ '\k'
          i += 1
        endwhile
        id = selector[start:(i - 1)]

      elseif c == '.'
        i += 1
        var start = i
        while i < len(selector) && selector[i] =~ '\k'
          i += 1
        endwhile
        classes->add(selector[start:(i - 1)])

      elseif c == '['
        var start = i + 1
        var end = stridx(selector, ']', start)
        attrs->add(selector[start:(end - 1)])
        i = end + 1
        continue

      else
        var start = i
        while i < len(selector) && selector[i] =~ '\k'
          i += 1
        endwhile
        tag_name = selector[start:(i - 1)]
        continue
      endif
    endwhile

    if tag_name->empty()
      tag_name = 'div'
    endif

  enddef
endclass

def ParseTag(input: string): dict<any>
  var leading = input[0] == '/'
  var trailing = input[-1] == '/'

  var selector = input
  if leading
    selector = selector[1 :]
  endif
  if trailing
    selector = selector[: -2]
  endif

  var tag_name = ''
  var id = ''
  var classes: list<string> = []
  var attrs: list<string> = []

  var i = 0
  while i < len(selector)
    var c = selector[i]

    if c == '#'
      i += 1
      var start = i
      while i < len(selector) && selector[i] =~ '\k'
        i += 1
      endwhile
      id = selector[start : i - 1]

    elseif c == '.'
      i += 1
      var start = i
      while i < len(selector) && selector[i] =~ '\k'
        i += 1
      endwhile
      classes->add(selector[start : i - 1])

    elseif c == '['
      var start = i + 1
      var end = stridx(selector, ']', start)
      attrs->add(selector[start : end - 1])
      i = end + 1
      continue

    else
      var start = i
      while i < len(selector) && selector[i] =~ '\k'
        i += 1
      endwhile
      tag_name = selector[start : i - 1]
      continue
    endif
  endwhile

  if tag_name == ''
    tag_name = 'div'
  endif

  var attrstr = ''

  if id != ''
    attrstr ..= ' id="' .. id .. '"'
  endif

  if len(classes) > 0
    attrstr ..= ' class="' .. join(classes, ' ') .. '"'
  endif

  for a in attrs
    if stridx(a, '=') >= 0
      var parts = split(a, '=')
      attrstr ..= ' ' .. parts[0] .. '="' .. parts[1] .. '"'
    else
      attrstr ..= ' ' .. a
    endif
  endfor

  var output: dict<any> = {
    tag_name: tag_name,
    attrs: attrs,
    classes: classes,
    id: id,
    leading: leading,
    trailing: trailing,
  }

  return output
enddef

# get current position:
# var position = getcharpos('.')
#
# set new position:
# setcharpos('.', position)

#nnoremap <silent> <leader>t :call <SID>XenWrite()<cr>
