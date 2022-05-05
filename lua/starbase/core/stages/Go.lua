local Go = {}
Go.__index = Go

function Go.new(self, go_settings, linter, lsp, mapper, nvim, plugin_manager, starbase_settings)
  return setmetatable({
    go_settings = go_settings,
    linter = linter,
    lsp = lsp,
    mapper = mapper,
    nvim = nvim,
    plugin_manager = plugin_manager,
    starbase_settings = starbase_settings,
  }, self)
end

function Go.configure(self)
  if not self.starbase_settings:get('stages.go.enabled') then return end

  self.plugin_manager:add_dependency('mattn/vim-goimports')

  self.plugin_manager:
    add_dependency('edolphin-ydf/goimpl.nvim', self:goimpl_setup()):
    add_dependency('nvim-lua/plenary.nvim'):
    add_dependency('nvim-lua/popup.nvim'):
    add_dependency('nvim-telescope/telescope.nvim'):
    add_dependency('nvim-treesitter/nvim-treesitter')


  local tag_list = self.go_settings:concat_buildtags(',')
  if tag_list ~= '' then
    self.nvim.g.nvim_dap_go_buildtags = tag_list
  end

  self.plugin_manager:add_dependency('abnt713/nvim-dap-go', self:debug_setup()):
    add_dependency('mfussenegger/nvim-dap')

  self.lsp:add_server('gopls', self:gopls_settings())
  self.linter:set_linters_for_ft('go', self.starbase_settings:get('stages.go.linters'))

  self:configure_debug_maps()
  self.mapper:leadermap('im', [[<cmd>lua require('telescope').extensions.goimpl.goimpl({})<CR>]])
end

function Go.configure_debug_maps(self)
  self.mapper:spacemap('db', [[<cmd>lua require('dap').toggle_breakpoint()<CR>]])
  self.mapper:spacemap('dc', [[<cmd>lua require('dap').continue()<CR>]])
  self.mapper:spacemap('di', [[<cmd>lua require('dap').step_into()<CR>]])
  self.mapper:spacemap('do', [[<cmd>lua require('dap').step_over()<CR>]])
  self.mapper:spacemap('dr', [[<cmd>lua require('dap').step_out()<CR>]])
  self.mapper:spacemap('d<C-b>', [[<cmd>require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]])
  self.mapper:spacemap('dd', [[<cmd>lua require('dap').repl.open()<CR>]])
  self.mapper:spacemap('dt', [[<cmd>lua require('dap-go').debug_test()<CR>]])
end

function Go.goimpl_setup()
  return function ()
    require('telescope').load_extension('goimpl')
  end
end

function Go.debug_setup()
  return function()
    require('dap-go').setup()
  end
end

function Go.gonvim_setup()
  return function()
    require('go').setup()
  end
end

function Go.gopls_settings(self)
  local tags_cmd = self:get_tags_command()
  local gopls_settings = {
    settings = {
      gopls = {
        buildFlags = {},
        env = nil,
      }
    },
  }

  if tags_cmd ~= '' then
    gopls_settings.settings.gopls['buildFlags'] = {tags_cmd}
    gopls_settings.settings.gopls['env'] = {GOFLAGS = tags_cmd}
  end

  return gopls_settings
end

function Go.get_tags_command(self)
  local tag_list = self.go_settings:concat_buildtags(',')
  if tag_list == '' then
    return ''
  end

  return "-tags=" .. tag_list
end

return Go
