class Palenight
  apply: (nvim, plugins) =>
    with plugins\require 'drewtempelmeyer/palenight.vim'
      \post_hook(@._setup_palenight nvim)

  _setup_palenight: (nvim) ->
    ->
      nvim.o.background = 'dark'
      nvim.g.palenight_terminal_italics = 1
      nvim.cmd 'colorscheme palenight'

Palenight