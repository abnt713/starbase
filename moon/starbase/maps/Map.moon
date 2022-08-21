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

  keys: (ks) =>
    @_ks = ks
    @

  cmd: (cmd) =>
    @_map = '<cmd>' .. cmd .. '<CR>'
    @

  maps_to: (map) =>
    @_map = map
    @

  apply: =>
    if not @_ks return
    if not @_map return

    ks = @_ks
    if @_prefix then ks = '<' .. @_prefix .. '>' .. ks
    @nvim.api.nvim_set_keymap @_mode, ks, @_map, @_options

Map