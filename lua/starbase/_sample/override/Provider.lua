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

-- stages overrides the default provider stages.
function Provider.stages(self)
  -- fetching the super.stages result.
  local override_stages = ParentProvider.stages(self)
  -- inserting the custom layer.
  table.insert(override_stages, self:custom())
  -- returning the changed result.
  return override_stages
end

-- custom provides the custom stage.
function Provider.custom(self)
  return require('starbase.override.Custom'):new(
    -- you can add custom dependencies here.
    self:nvim()
  )
end

return Provider