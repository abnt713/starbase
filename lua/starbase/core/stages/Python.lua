local Python = {}
Python.__index = Python

function Python.new(self, fs, linter, lsp, starbase_settings)
  return setmetatable({
    fs = fs,
    linter = linter,
    lsp = lsp,
    starbase_settings = starbase_settings,
  }, self)
end

function Python.configure(self)
  if not self.starbase_settings:get('stages.python.enabled') then return end
  self.lsp:add_server('pyright', self:pyright_settings())
  self.linter:set_linters_for_ft('python', self.starbase_settings:get('stages.python.linters'))
end

function Python.pyright_settings()
  return {}
end

return Python