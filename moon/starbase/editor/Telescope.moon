class Telescope
  apply: (nvim, plugins, maps) =>
    with plugins\require 'nvim-telescope'
      \post_hook(@_setup_telescope maps)
      \require 'nvim-lua/popup.nvim'
      \require 'nvim-lua/plenary.nvim'

  _setup_telescope: (maps) =>
    ->
      require('telescope').setup {}
      with maps\add!\space!
        \keys('ff')\cmd('Telescope find_files')\apply!
        \keys('fg')\cmd('Telescope live_grep')\apply!
        \keys('fb')\cmd('Telescope buffers')\apply!
        \keys('fh')\cmd('Telescope help_tags')\apply!

Telescope