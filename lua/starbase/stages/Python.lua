local Python = {}
Python.__index = Python

function Python.new(self, fs, linter, lsp, project_settings, starbase_settings)
  return setmetatable({
    fs = fs,
    linter = linter,
    lsp = lsp,
    project_settings = project_settings,
    starbase_settings = starbase_settings,
  }, self)
end

function Python.configure(self)
  if not self.starbase_settings:get('stages.python.enabled') then return end
  self.lsp:add_server('pyright', self:pyright_settings())
  self.linter:set_linters_for_ft('python', self.starbase_settings:get('stages.python.linters'))
end

function Python.pyright_settings(self)
  local settings = {python = {}}

  local venv_path = self.project_settings:get('python.venv_path')
  if venv_path then
    settings.python.venvPath = venv_path
  end

  local venv = self.project_settings:get('python.venv')
  if venv_path then
    settings.python.venv = venv
  end

  return settings
end

return Python
