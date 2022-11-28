class Palenight
  id: ->
    'palenight'

  apply: (nvim, plugins) =>
    with plugins\require 'drewtempelmeyer/palenight.vim'
      \post_hook(@_setup_palenight nvim)

  _setup_palenight: (nvim) =>
    ->
      nvim.o.background = 'dark'
      nvim.g.palenight_terminal_italics = 1
      nvim.g.palenight_color_overrides = {
        'black': {
          'gui': '#0A0E14',
          "cterm": "235",
          "cterm16": "0"
        },
        'cursor_grey': {
          'gui': '#242732',
          "cterm": "237",
          "cterm16": "15"
        }
      }
      nvim.cmd 'colorscheme palenight'
