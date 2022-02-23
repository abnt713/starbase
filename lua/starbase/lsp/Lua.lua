local Lua = {}
Lua.__index = Lua

function Lua.new(nvim, starbase_settings)
  return setmetatable({
    nvim = nvim,
    starbase_settings = starbase_settings,
  }, Lua)
end

function Lua.enabled(self)
  return self.starbase_settings:get('layers.lua.enabled')
end

function Lua.get_lsp_settings(self)
  local runtime_path = self.nvim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  return 'sumneko_lua', {
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
