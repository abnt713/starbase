class Cmp
  new: (lsp) =>
    @lsp = lsp

  apply: (nvim, plugins, maps) =>
    nvim.o.completeopt = 'menu,menuone,noselect'

    plugins\require 'hrsh7th/cmp-nvim-lsp'
    plugins\require 'hrsh7th/cmp-buffer'
    plugins\require 'hrsh7th/cmp-path'

    plugins\require 'L3MON4D3/LuaSnip'
    plugins\require 'saadparwaiz1/cmp_luasnip'

    with plugins\require 'hrsh7th/nvim-cmp'
      \post_hook(@_setup_cmp!)

  _setup_cmp: =>
    ->
      with cmp = require('cmp')
        .setup {
          snippet: {
            expand: (args) ->
              require('luasnip').lsp_expand args.body
          },
          mapping: {
            ['<CR>']: cmp.mapping.confirm({ select: true }),
            ['<C-Space>']: cmp.mapping(cmp.mapping.complete!, { 'i', 'c' }),
            ['<Tab>']: cmp.mapping(((fallback) ->
              if cmp.visible!
                cmp.select_next_item!
                return
              fallback!
            ), { 'i', 's' }),
            ['<S-Tab>']: cmp.mapping(((fallback) ->
              if cmp.visible!
                cmp.select_prev_item!
                return
              fallback!
            ), { 'i', 's' }),
          },
          sources: cmp.config.sources {
            { name: 'nvim_lsp' },
            { name: 'buffer' },
            { name: 'path' },
          }
        }

Cmp