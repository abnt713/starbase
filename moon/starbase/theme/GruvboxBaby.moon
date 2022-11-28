class GruvboxBaby
  id: =>
    'gruvbox-baby'

  apply: (nvim, plugins) =>
    with plugins\require 'luisiacc/gruvbox-baby'
      \post_hook(@_setup_gruvbox_baby nvim)

  _setup_gruvbox_baby: (nvim) =>
    ->
      nvim.o.background = 'dark'
      nvim.cmd 'colorscheme gruvbox-baby'
