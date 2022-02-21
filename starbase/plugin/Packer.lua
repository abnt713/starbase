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
  return require('packer').startup(function()
    local total = 0
    for k, v in pairs(self.dependencies) do
      use(v:flatten())
    end
  end)
end

function Packer.flatten(self)
  if self.is_root then return end

  local pdep = {self.plugin_name}
  if self.config then pdep['config'] = self.config end
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



return Packer
