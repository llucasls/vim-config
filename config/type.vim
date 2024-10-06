" Get human-readable types from values
const s:t_null = 7

const s:types = {
      \ v:t_number: 'number',
      \ v:t_string: 'string',
      \ v:t_func: 'func',
      \ v:t_list: 'list',
      \ v:t_dict: 'dict',
      \ v:t_float: 'float',
      \ v:t_bool: 'bool',
      \ s:t_null: 'null',
      \ v:t_blob: 'blob'}

function Type(obj)
  return s:types[type(a:obj)]
endfunction
