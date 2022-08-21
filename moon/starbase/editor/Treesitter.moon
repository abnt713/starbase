class Treesitter
  apply: (nvim, plugins, maps) =>
    with plugins\require 'nvim-treesitter/nvim-treesitter'
      \post_hook(@_setup_treesitter plugins)
      \run -> vim.cmd 'TSUpdate'

  _setup_treesitter: (plugins) =>
    ->
      with require 'nvim-treesitter.configs'
        .setup {
          highlight: { enable: true },
          indent: {
            enable: false
          },
          playground: {
            enable: true,
            disable: {},
            updatetime: 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries: false, -- Whether the query persists across vim sessions
            keybindings: {
              toggle_query_editor: 'o',
              toggle_hl_groups: 'i',
              toggle_injected_languages: 't',
              toggle_anonymous_nodes: 'a',
              toggle_language_display: 'I',
              focus_language: 'f',
              unfocus_language: 'F',
              update: 'R',
              goto_node: '<cr>',
              show_help: '?',
            },
          }
        }

Treesitter