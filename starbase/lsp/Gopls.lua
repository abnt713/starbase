local Gopls = {}
Gopls.__index = Gopls

function Gopls.new(go_settings, plugin_manager)
  return setmetatable({
    go_settings = go_settings,
    plugin_manager = plugin_manager,
  }, Gopls)
end

function Gopls.configure(self)
  self.plugin_manager:add_dependency('mattn/vim-goimports')
end

function Gopls.get_lsp_settings(self)
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

  return 'gopls', gopls_settings
end

return Gopls
