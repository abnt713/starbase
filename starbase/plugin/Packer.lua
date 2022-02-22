Packer = {}
Packer.__index = Packer

function Packer.new(nvim)
  obj = setmetatable({
    is_root = true,
    nvim = nvim,
    dependencies = {}
  }, Packer)

  obj:add_dependency('wbthomason/packer.nvim')
  return obj
end

function Packer.add_dependency(self, plugin_name, config, opts)
  dep = {
    plugin_name = plugin_name,
    config = config,
    opts = opts,

    dependencies = {},
    nvim = self.nvim,
  }
  packer_dep = setmetatable(dep, Packer)
  table.insert(self.dependencies, packer_dep)

  return packer_dep
end

function Packer.evaluate(self)
  if not self.is_root then return end
  local packer_result = require('packer').startup(function()
    local total = 0
    for k, v in pairs(self.dependencies) do
      use(v:flatten())
    end
  end)

  self:configure()
  return packer_result
end

function Packer.require(self, requirement, should_fail)
  local call_fails = should_fail or false 
  local module = nil
  local status = pcall(function()
    module = require(requirement)
  end)

  if not status and not should_fail then
    self:sync()
    return self:require(requirement, true)
  end

  if not status then 
    print(string.format('Missing "%s" dependency! Syncing all plugins... Please reload the editor once finished', requirement))
    return nil
  end

  return module
end

function Packer.run(self, action_fn, should_fail)
  local call_fails = should_fail or false 
  local status, err = pcall(function()
    action_fn()
  end)

  if not status and not should_fail then
    self:sync()
    return self:run(action_fn, true)
  end

  if not status then 
    print('Missing dependencies! Syncing all plugins... Please reload the editor once finished')
    return false
  end

  return true
end

function Packer.sync(self)
  require('packer').sync()
end

function Packer.flatten(self)
  if self.is_root then return end

  local pdep = {self.plugin_name}
  -- if self.config then pdep['config'] = self.config end
  if self.opts then pdep = self.nvim.tbl_extend('force', pdep, self.opts) end

  local requires = {}
  local total_dependencies = 0
  for k in pairs(self.dependencies) do
    total_dependencies = total_dependencies + 1
    local flattened_dep = self.dependencies[k]:flatten()
    table.insert(requires, flattened_dep)
  end

  if total_dependencies > 0 then
    pdep['requires'] = requires
  end

  return pdep
end

function Packer.configure(self)
  if self.config then self.config() end
  for k, v in pairs(self.dependencies) do
    v:configure()
  end
end

return Packer
