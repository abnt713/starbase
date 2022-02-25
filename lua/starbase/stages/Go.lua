local Go = {}
Go.__index = Go

function Go.new(self, go_settings, linter, lsp, plugin_manager, starbase_settings)
  return setmetatable({
    go_settings = go_settings,
    linter = linter,
    lsp = lsp,
    plugin_manager = plugin_manager,
    starbase_settings = starbase_settings,
  }, self)
end

function Go.configure(self)
  if not self.starbase_settings:get('layers.go.enabled') then return end
  self.plugin_manager:add_dependency('mattn/vim-goimports')
  self.lsp:add_server('gopls', self:gopls_settings())
  self.linter:set_linters_for_ft('go', self.starbase_settings:get('layers.go.linters'))
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
