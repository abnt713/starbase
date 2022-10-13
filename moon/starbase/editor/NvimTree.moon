class NvimTree
  id: =>
    'luatree'

  apply: (nvim, plugins, maps) =>
    with plugins\require 'nvim-tree/nvim-tree.lua'
      \require 'nvim-tree/nvim-web-devicons'
      \post_hook @_setup_nvim_tree()

    maps\add!\space!\keys('ft')\cmd('NvimTreeToggle')\apply!

  _setup_nvim_tree: =>
    ->
      require('nvim-tree').setup!

NvimTree
