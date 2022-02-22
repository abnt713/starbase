LanguageServerProtocol = {}
LanguageServerProtocol.__index = LanguageServerProtocol

function LanguageServerProtocol.new(lsp_capabilities, mapper, nvim, plugin_manager, servers)
  return setmetatable({
    lsp_capabilities = lsp_capabilities,
    mapper = mapper,
    nvim = nvim,
    plugin_manager = plugin_manager,
    servers = servers,
  }, LanguageServerProtocol)
end

function LanguageServerProtocol.configure(self)
  self.plugin_manager:add_dependency('nvim-lua/completion-nvim')
  self.plugin_manager:add_dependency('nvim-lua/lsp_extensions.nvim')
  self.plugin_manager:add_dependency('ojroques/nvim-lspfuzzy')

  self.plugin_manager:add_dependency('neovim/nvim-lspconfig', self:setup_lsp())
end

function LanguageServerProtocol.setup_lsp(self)
  return function()
    local lspcfg = self.plugin_manager:require('lspconfig')
    if not lspcfg then return end

    local lspfuzzy = self.plugin_manager:require('lspfuzzy')
    if not lspfuzzy then return end

    local capabilities = self.lsp_capabilities:retrieve_capabilities()
    for k, server in pairs(self.servers) do
      server:configure(lspcfg, capabilities)
    end

    lspfuzzy.setup({})
  end
end

return LanguageServerProtocol
