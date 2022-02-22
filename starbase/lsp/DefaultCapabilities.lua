DefaultCapabilities = {}
DefaultCapabilities.__index = DefaultCapabilities

function DefaultCapabilities.new()
  return setmetatable({}, DefaultCapabilities)
end

function DefaultCapabilities.retrieve_capabilities(self)
  return nil
end

return DefaultCapabilities
