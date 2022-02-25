local Lua = {}
Lua.__index = Lua

function Lua.new(self, linter, lsp, nvim, plugin_manager, starbase_settings)
  return setmetatable({
    linter = linter,
    lsp = lsp,
    nvim = nvim,
    plugin_manager = plugin_manager,
    starbase_settings = starbase_settings,
  }, self)
end

function Lua.configure(self)
  if not self.starbase_settings:get('layers.lua.enabled') then return end
  self.lsp:add_server('sumneko_lua', self:sumneko_lua_settings())
  self.linter:set_linters_for_ft('lua', self.starbase_settings:get('layers.lua.linters'))
end

function Lua.sumneko_lua_settings(self)
  local runtime_path = self.nvim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  return {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = self.nvim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

return Lua
