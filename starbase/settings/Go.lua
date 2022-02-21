Go = {}
Go.__index = Go

function Go.new(go_contents)
  return setmetatable({
    contents = go_contents,
  }, Go)
end

function Go.concat_buildtags(self, separator)
  if self.contents.tags == nil then return nil end
  return table.concat(self.contents.tags, separator)
end

return Go
