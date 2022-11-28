class AyuDark
  id: =>
    'ayu-dark'

  apply: (nvim, plugins) =>
    with plugins\require 'Shatur/neovim-ayu'
      \post_hook(@_setup_ayu nvim)

  _setup_ayu: (nvim) =>
    ->
      with require 'ayu'
        .setup {
          mirage: false,
          overrides: {}
        }
        .colorscheme!
