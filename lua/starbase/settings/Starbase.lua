local Starbase = {}
Starbase.__index = Starbase

function Starbase.new(settings_builder)
  local default = settings_builder:from_requirement('starbase.defaults.config')
  local user = settings_builder:from_requirement('starbase.custom.config')

  return setmetatable({
    default = default,
    user = user,
  }, Starbase)
end

return Starbase
