class Map
  new: (nvim) =>
    @nvim = nvim
    @mode = 'n'
    @options = {noremap: true}

  leader: =>
    @prefix = 'leader'

  space: =>
    @prefix = 'space'

  mode: (mode) =>
    @mode = mode

  key_sequence: (ks) =>
    @ks = ks

  cmd: (cmd) =>
    @cmd = cmd

  apply: =>
    if not @ks return
    @nvim.api.nvim_set_keymap @mode, @ks, @cmd, @options