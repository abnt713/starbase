local Settings = {}
Settings.__index = Settings

function Settings.new(contents)
  return setmetatable({
    contents = contents,
  }, Settings)
end

function Settings.from_requirement(_, requirement)
  local content = nil
  local ok = pcall(function()
    content = require(requirement)
  end)

  if not ok then
    content = {}
  end

  return Settings.new(content)
end

function Settings.from_contents(_, contents)
  return Settings.new(contents)
end

function Settings.get(self, setting)
  local value = self.contents

  for setting_value in string.gmatch(setting, '(%w+)') do
    if type(value) ~= 'table' then return nil end
    value = value[setting_value]
  end

  return value
end

return Settings
