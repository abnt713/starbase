class LSP
  new: =>
    @servers = {}

  id: =>
    'lsp'

  add_server: (name, settings) =>
    table.insert @servers, {name: name, settings: settings}

  set_capabilities: (capabilities) =>
    @capabilities = capabilities

  apply: (nvim, plugins, maps) =>
    plugins\require 'ojroques/nvim-lspfuzzy'
    with plugins\require 'neovim/nvim-lspconfig'
      \post_hook(@_setup_lsp nvim, maps)

  _setup_lsp: (nvim, maps) =>
    ->
      lspcfg = require 'lspconfig'
      for _, s in pairs @servers
        if @capabilities then s.settings['capabilities'] = @capabilities
        lspcfg[s.name].setup s.settings

      require('lspfuzzy').setup {}
      nvim.diagnostic.config {virtual_text: true}
      nvim.o.updatetime = 500
      @_setup_maps maps

  _setup_maps: (maps) =>
    with maps\add!
      \keys('ga')\lua('vim.lsp.buf.code_action()')\apply!
      \keys('gh')\lua('vim.lsp.buf.hover()')\apply!
      \keys('gD')\lua('vim.lsp.buf.declaration()')\apply!
      \keys('gd')\lua('vim.lsp.buf.definition()')\apply!
      \keys('gr')\lua('vim.lsp.buf.references()')\apply!
      \keys('gi')\lua('vim.lsp.buf.implementation()')\apply!
      \keys('gs')\lua('vim.lsp.buf.signature_help()')\apply!
      \keys('gl')\lua('vim.diagnostic.open_float(nil, {focus=false})')\apply!
      \keys('gn')\lua('vim.diagnostic.goto_next()')\apply!
      \keys('gp')\lua('vim.diagnostic.goto_prev()')\apply!

    with maps\add!\leader!
      \keys('rn')\cmd('lua vim.lsp.buf.rename()')\apply!

LSP
