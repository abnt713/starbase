local Defaults = {}
Defaults.__index = Defaults

function Defaults.new(defaults)
  return setmetatable({
    defaults = defaults,
  }, Defaults)
end

function Defaults.get(self, setting)
  local value = self.defaults

  for setting_value in string.gmatch(setting, '(%w+)') do
    if type(value) ~= 'table' then return nil end
    value = value[setting_value]
  end

  return value
end

return Defaults
