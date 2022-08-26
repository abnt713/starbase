class Svelte
  new: (lsp) =>
    @lsp = lsp

  id: =>
    'svelte'

  apply: (nvim, plugins, maps) =>
    plugins\require 'leafOfTree/vim-svelte-plugin'
    @lsp\add_server 'svelte', {}

Svelte
