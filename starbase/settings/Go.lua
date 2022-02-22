local Go = {}
Go.__index = Go

function Go.new(settings)
  return setmetatable({
    settings = settings,
  }, Go)
end

function Go.concat_buildtags(self, separator)
  local tags = self.settings:get('go.tags')
  if tags == nil then return nil end
  return table.concat(tags, separator)
end

return Go
