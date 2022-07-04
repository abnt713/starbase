local Rust = {}
Rust.__index = Rust

function Rust.new(self, lsp, starbase_settings)
  return setmetatable({
    lsp = lsp,
    starbase_settings = starbase_settings,
  }, self)
end

function Rust.configure(self)
  if not self.starbase_settings:get('stages.rust.enabled') then return end
  self.lsp:add_server('rust_analyzer', self:lsp_settings())
end

function Rust.lsp_settings()
  return {}
end

return Rust