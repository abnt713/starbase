class Map
  new: (nvim, _funcs) =>
    @nvim = nvim
    @_funcs = _funcs

    @_mode = 'n'
    @_options = {noremap: true}

  leader: =>
    @_prefix = 'leader'
    @

  space: =>
    @_prefix = 'space'
    @

  mode: (mode) =>
    @_mode = mode
    @

  keys: (keys) =>
    @_keys = keys
    @

  cmd: (cmd) =>
    @maps_to '<cmd>' .. cmd .. '<CR>'

  fn: (name, fn) =>
    @_funcs[name] = fn
    @lua "_mapped_functions['" .. name .. "']()"

  lua: (cmd) =>
    @cmd 'lua ' .. cmd

  maps_to: (map) =>
    @_map = map
    @

  apply: =>
    if not @_keys return
    if not @_map return

    keys = @_keys
    if @_prefix then keys = '<' .. @_prefix .. '>' .. keys
    @nvim.api.nvim_set_keymap @_mode, keys, @_map, @_options

Map
