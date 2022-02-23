local PackerInstaller = {}
PackerInstaller.__index = PackerInstaller

function PackerInstaller.new(nvim, packer)
  return setmetatable({
    nvim = nvim,
    packer = packer,
    packer_boostraped = nil,
  }, PackerInstaller)
end

function PackerInstaller.configure(self)
  local install_path = self.nvim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if self.nvim.fn.empty(self.nvim.fn.glob(install_path)) > 0 then
    print('Packer not found! Installing...')
    self.packer_boostraped = self.nvim.fn.system(
      {'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path}
    )
  end
end

function PackerInstaller.add_dependency(self, plugin_name, config, opts)
  if self.packer_boostraped then return self end
  return self.packer:add_dependency(plugin_name, config, opts)
end

function PackerInstaller.evaluate(self)
  if self.packer_boostraped then 
    print('Finished! Please restart the editor...')
    return nil
  end
  return self.packer:evaluate()
end

function PackerInstaller.require(self, requirement)
  if self.packer_bootstraped then return nil end
  return self.packer:require(requirement)
end

function PackerInstaller.run(self, action_fn, should_fail)
  if self.packer_bootstraped then return false end
  return self.packer:run(action_fn, should_fail)
end

return PackerInstaller
