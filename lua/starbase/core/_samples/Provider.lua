-- This one is a custom provider. Use this instance to override any DI decision.
-- It is important to place this file in the import path "starbase.override.Provider".
-- If no file is found in this path, the application will use the default Provider.
local ParentProvider = require('starbase.core.Provider')
local Provider = setmetatable({}, ParentProvider)
Provider.__index = Provider

function Provider.new(self, nvim)
  local obj = ParentProvider:new(nvim)
  return setmetatable(obj, self)
end

-- This method overrides the default stages configuration and adds another stage with
-- extra vim configurations (and Tetris, why not :D) 
-- This is just an exemple on how to override all the standart structures through
-- provider overriding. Notice that resolving dependencies also work here.
function Provider.stages(self)
  local nvim = self:nvim()
  local plugin_manager = self:plugin_manager()
  local extra_stage = {
    configure = function()
      nvim.opt.colorcolumn = '120'
      plugin_manager:add_dependency('alec-gibson/nvim-tetris')
    end
  }
  local override_stages = ParentProvider.stages(self)
  table.insert(override_stages, extra_stage)
  return override_stages
end

-- Another example: this method overrides the default theme setting and uses the Rigel theme.
function Provider.theme(self)
  return self:provide('theme', function()
    return require('starbase.core.tools.theme.Rigel').new(
      self:nvim(),
      self:plugin_manager(),
      self:statusline()
    )
  end)
end

return Provider
