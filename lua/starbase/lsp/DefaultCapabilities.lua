local DefaultCapabilities = {}
DefaultCapabilities.__index = DefaultCapabilities

function DefaultCapabilities.new()
  return setmetatable({}, DefaultCapabilities)
end

function DefaultCapabilities.retrieve_capabilities()
  return nil
end

return DefaultCapabilities
