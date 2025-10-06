vim9script
interface Conceals
  def Conceal(): void
  def Clear(): void
endinterface

export class TailwindConceal implements Conceals
  var chars: number
  var words: number
  var priority: number
  final _char_ids: list<number> = []
  final _word_ids: list<number> = []

  def new(data: dict<any>)
    var chars = <number>this._GetValue(data, 'chars')
    var words = <number>this._GetValue(data, 'words')
    if chars < 0
      throw 'TailwindConceal: ''chars'' can''t be negative'
    endif
    if words < 0
      throw 'TailwindConceal: ''words'' can''t be negative'
    endif

    this.chars = chars
    this.words = words
    this.priority = <number>this._GetValue(data, 'priority', 10)
  enddef

  def empty(): bool
    return this.chars == 0 && this.words == 0
  enddef

  def SetChars(value: number): void
    if value < 0
      throw 'SetChars: negative values are not supported'
    elseif value == 0
      this.chars = 0
      this._ClearCharMatches()
    else
      this.chars = <number>value
      this._ClearCharMatches()
      this._ConcealByChars()
    endif
  enddef

  def SetWords(value: number): void
    if value < 0
      throw 'SetWords: negative values are not supported'
    elseif value == 0
      this.words = 0
      this._ClearWordMatches()
    else
      this.words = <number>value
      this._ClearWordMatches()
      this._ConcealByWords()
    endif
  enddef

  def Conceal(): void
    this._ConcealByChars()
    this._ConcealByWords()
  enddef

  def Clear(): void
    this.chars = 0
    this.words = 0
    this._ClearCharMatches()
    this._ClearWordMatches()
  enddef

  def _GetValue(data: dict<any>, key: string, default: any = 0): any
    return has_key(data, key) ? data[key] : default
  enddef

  def _ConcealByChars(): void
    this._ClearCharMatches()

    if this.chars != 0
      var num: number = this.chars
      var group: string = 'Conceal'
      var priority: number = this.priority
      var id: number = -1  # take the next available id

      var opts = {conceal: '.'}
      var i = 0
      var n = 2
      var delimiters = '"'''
      var d: string
      var cls: string

      while i < n
        d = delimiters[i]
        cls = 'class\(Name\)\?'

        var pat_a = $'{cls}={d}\zs[^{d}]\ze\([^{d}]\{{{num},}}\)[^{d}]{d}'
        var pat_b = $'{cls}={d}[^{d}]\zs\([^{d}]\{{{num},}}\)\ze[^{d}]{d}'
        var pat_c = $'{cls}={d}[^{d}]\([^{d}]\{{{num},}}\)\zs[^{d}]\ze{d}'

        add(this._char_ids, matchadd(group, pat_a, priority, id, opts))
        add(this._char_ids, matchadd(group, pat_b, priority, id, opts))
        add(this._char_ids, matchadd(group, pat_c, priority, id, opts))

        i += 1
      endwhile
    endif
  enddef

  def _ConcealByWords(): void
    this._ClearWordMatches()

    if this.words != 0
      var num: number = this.words
      var group: string = 'Conceal'
      var priority: number = this.priority
      var id: number = -1  # take the next available id

      var opts = {conceal: '.'}
      var i = 0
      var n = 2
      var delimiters = '"'''
      var d: string
      var cls: string

      while i < n
        d = delimiters[i]
        cls = 'class\(Name\)\?'

        var pat_a = $'{cls}={d}\zs[^{d}]\+\ze\([^{d} ]\+ \)\{{{num},}}[^{d}]\+[^{d}]\+{d}'
        var pat_b = $'{cls}={d}[^{d}]\+\zs\([^{d} ]\+ \)\{{{num},}}[^{d}]\+\ze[^{d}]\+{d}'
        var pat_c = $'{cls}={d}[^{d}]\+\([^{d} ]\+ \)\{{{num},}}[^{d}]\+\zs[^{d}]\+\ze{d}'

        add(this._word_ids, matchadd(group, pat_a, priority, id, opts))
        add(this._word_ids, matchadd(group, pat_b, priority, id, opts))
        add(this._word_ids, matchadd(group, pat_c, priority, id, opts))

        i += 1
      endwhile
    endif
  enddef

  def _ClearCharMatches(): void
    for id in this._char_ids
      matchdelete(id)
    endfor
    var n = this._char_ids->len()
    if n > 0
      this._char_ids->remove(0, n - 1)
    endif
  enddef

  def _ClearWordMatches(): void
    for id in this._word_ids
      matchdelete(id)
    endfor
    var n = this._word_ids->len()
    if n > 0
      this._word_ids->remove(0, n - 1)
    endif
  enddef
endclass
