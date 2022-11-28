class TokyoDark
  id: =>
    'tokyo-dark'

  apply: (nvim, plugins) =>
    with plugins\require 'tiagovla/tokyodark.nvim'
      \post_hook(@_setup_tokyodark nvim)

  _setup_tokyodark: (nvim) =>
    ->
      nvim.o.background = 'dark'
      nvim.g.tokyodark_enable_italic_comment = 1
      nvim.g.tokyodark_enable_italic = 1
      nvim.g.tokyodark_color_gamma = "1.0"
      nvim.cmd 'colorscheme tokyodark'
