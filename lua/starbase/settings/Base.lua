local Base = {}
Base.__index = Base

function Base.new(settings_builder)
  local default = settings_builder:from_requirement('starbase.assets.config')
  local user = settings_builder:from_requirement('starbase.config')

  return setmetatable({
    default = default,
    user = user,
  }, Base)
end

return Base
