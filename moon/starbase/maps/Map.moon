class Map
  new: (nvim) =>
    @nvim = nvim
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
    @_map = '<cmd>' .. cmd .. '<CR>'
    @

  lua: (cmd) =>
    @cmd 'lua ' .. cmd
    @

  maps_to: (map) =>
    @_map = map
    @

  apply: =>
    if not @_ks return
    if not @_map return

    keys = @_keys
    if @_prefix then keys = '<' .. @_prefix .. '>' .. keys
    @nvim.api.nvim_set_keymap @_mode, keys, @_map, @_options

Map
