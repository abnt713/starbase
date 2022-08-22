class Go
  new: (proj, lsp, linter) =>
    @proj = proj
    @lsp = lsp
    @linter = linter

  id: =>
    'go'

  apply: (nvim, plugins, maps) =>
    plugins\require 'mattn/vim-goimports'

    with plugins\require 'abnt713/nvim-dap-go'
      \post_hook @setup_debug!
      \require 'mfussenegger/nvim-dap'

    with plugins\require 'edolphin-ydf/goimpl.nvim'
      \post_hook @setup_goimpl!
      \require 'nvim-lua/plenary.nvim'
      \require 'nvim-lua/popup.nvim'
      \require 'nvim-telescope/telescope.nvim'
      \require 'nvim-treesitter/nvim-treesitter'

    tags = @get_tags!
    if tags != ''
      nvim.g.nvim_dap_go_buildtags = tags

    @lsp\add_server 'gopls', @gopls_settings!
    @linter\set 'go', {'revive'}

    with maps\add!\leader!
      \keys('im')\lua([[require('telescope').extensions.goimpl.goimpl({})]])\apply!

    with maps\add!\space!
      \keys('dt')\lua([[require('dap-go').debug_test()]])\apply!

  get_tags: =>
    tags = @proj\get('go.tags', {})
    table.concat tags, ','

  gopls_settings: =>
    tags = @get_tags!
    if tags == '' return {}

    tags_flag = '-tags=' .. tags
    {
      settings: {
        gopls: {
          buildFlags: {tags_flag},
          env: {GOFLAGS: tags_flag}
        }
      }
    }

  setup_goimpl: =>
    -> require('telescope').load_extension('goimpl')
  
  setup_debug: =>
    -> require('dap-go').setup()

Go
