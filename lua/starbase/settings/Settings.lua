local Settings = {}
Settings.__index = Settings

function Settings.new(contents, fallback)
  return setmetatable({
    contents = contents,
    fallback = fallback,
  }, Settings)
end

function Settings.from_requirement(_, requirement, fallback)
  local content = nil
  local ok = pcall(function()
    content = require(requirement)
  end)

  if not ok then
    content = {}
  end

  return Settings.new(content, fallback)
end

function Settings.from_contents(_, contents, fallback)
  return Settings.new(contents, fallback)
end

function Settings.get(self, setting)
  local main_value = self:get_from_contents(setting)
  if not self.fallback then return main_value end

  if main_value == nil then
    return self.fallback:get(setting)
  end

  return main_value
end

function Settings.get_from_contents(self, setting)
  local value = self.contents

  for setting_value in string.gmatch(setting, '(%w+)') do
    if type(value) ~= 'table' then return nil end
    value = value[setting_value]
  end

  return value
end

return Settings
