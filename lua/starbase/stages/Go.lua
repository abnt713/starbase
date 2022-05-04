local Go = {}
Go.__index = Go

function Go.new(self, go_settings, linter, lsp, mapper, plugin_manager, starbase_settings)
  return setmetatable({
    go_settings = go_settings,
    linter = linter,
    lsp = lsp,
    mapper = mapper,
    plugin_manager = plugin_manager,
    starbase_settings = starbase_settings,
  }, self)
end

function Go.configure(self)
  if not self.starbase_settings:get('stages.go.enabled') then return end
  self.plugin_manager:add_dependency('mattn/vim-goimports')
  local goimpl = self.plugin_manager:add_dependency('edolphin-ydf/goimpl.nvim', self:goimpl_setup())
  goimpl:add_dependency('nvim-lua/plenary.nvim')
  goimpl:add_dependency('nvim-lua/popup.nvim')
  goimpl:add_dependency('nvim-telescope/telescope.nvim')
  goimpl:add_dependency('nvim-treesitter/nvim-treesitter')
  self.lsp:add_server('gopls', self:gopls_settings())
  self.linter:set_linters_for_ft('go', self.starbase_settings:get('stages.go.linters'))

  self.mapper:leadermap('im', [[<cmd>lua require('telescope').extensions.goimpl.goimpl({})<CR>]])
end

function Go.goimpl_setup()
  return function ()
    require('telescope').load_extension('goimpl')
  end
end

function Go.gonvim_setup()
  return function()
    require('go').setup()
  end
end

function Go.gopls_settings(self)
  local tag_list = self.go_settings:concat_buildtags(',')
  local gopls_settings = {
    settings = {
      gopls = {
        buildFlags = {},
        env = nil,
      }
    },
  }

  if tag_list ~= '' then
    gopls_settings.settings.gopls['buildFlags'] = {"-tags=" .. tag_list}
    gopls_settings.settings.gopls['env'] = {GOFLAGS = "-tags=" .. tag_list}
  end

  return gopls_settings
end

return Go
