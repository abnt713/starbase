local LanguageServerProtocol = {}
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
    for _, server in pairs(self.servers) do
      local lsp_name, settings = server:get_lsp_settings()
      if capabilities then settings['capabilities'] = capabilities end
      lspcfg[lsp_name].setup(settings)
    end

    lspfuzzy.setup({})
    self.nvim.diagnostic.config({virtual_text = false})

    self.nvim.o.updatetime = 250
    self.nvim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

    self.mapper:map('ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', 'show code actions')
    self.mapper:map('gh', '<cmd>lua vim.lsp.buf.hover()<CR>', 'hover over current code')
    self.mapper:map('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', 'go to declaration')
    self.mapper:map('gd', '<cmd>lua vim.lsp.buf.definition()<CR>', 'go to definition')
    self.mapper:map('gr', '<cmd>lua vim.lsp.buf.references()<CR>', 'list references')
    self.mapper:map('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', 'go to implementation')
    self.mapper:map('gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'display signature help')
    self.mapper:leadermap('rn', '<cmd>lua vim.lsp.buf.rename()<CR>', 'rename current symbol')
  end
end

return LanguageServerProtocol
