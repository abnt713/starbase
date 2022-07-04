local Custom = {}
Custom.__index = Custom

function Custom.new(self, nvim)
  return setmetatable({
    nvim = nvim,
  }, self)
end

function Custom.configure(self)
  -- Add your custom instructions here.
end

return Custom