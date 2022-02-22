Gopls = {}
Gopls.__index = Gopls

function Gopls.new(go_settings)
  return setmetatable({
    go_settings = go_settings,
  }, Gopls)
end

function Gopls.configure(self, lspcfg, capabilities)
  local tag_list = self.go_settings:concat_buildtags(',')
  local gopls_settings = {
    settings = {
      gopls = {
        buildFlags = {},
        env = nil,
      }
    },
  }

  if capabilities then settings['capabilities'] = capabilities end

  if tag_list ~= '' then
    gopls_settings.settings.gopls['buildFlags'] = {"-tags=" .. tag_list}
    gopls_settings.settings.gopls['env'] = {GOFLAGS = "-tags=" .. tag_list}
  end

  lspcfg.gopls.setup(gopls_settings)
end

return Gopls
