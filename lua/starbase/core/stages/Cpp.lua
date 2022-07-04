local Cpp = {}
Cpp.__index = Cpp

function Cpp.new(self, lsp, starbase_settings)
  return setmetatable({
    lsp = lsp,
    starbase_settings = starbase_settings,
  }, self)
end

function Cpp.configure(self)
  if not self.starbase_settings:get('stages.cpp.enabled') then return end
  self.lsp:add_server('ccls', self:ccls_settings())
end

function Cpp.ccls_settings()
  return {}
end

return Cpp