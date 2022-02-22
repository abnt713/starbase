Provider = {}
Provider.__index = Provider

function Provider:new()
  local o = {
    is_running_vim = (vim ~= nil),
    instances = {},
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Provider.starbase(self)
  return self:provide('starbase', function()
    return require('starbase.app.Starbase').new(
      self:editor_aspect(),
      self:filetree(),
      self:plugin_manager(),
      self:treesitter()
    )
  end)
end

function Provider.codec(self)
  return self:provide('codec', function()
    return require('starbase.utils.codec.NvimJsonCodec').new(self:nvim())
  end)
end

function Provider.file_system(self)
  return self:provide('fs', function()
    return require('starbase.utils.file.NvimFileSystem').new(self:nvim())
  end)
end

function Provider.filetree(self)
  return self:provide('filetree', function()
    return require('starbase.aspects.NERDTree').new(self:plugin_manager(), self:mapper())
  end)
end

function Provider.mapper(self)
  return self:provide('mapper', function()
    return require('starbase.utils.map.NvimMapper').new(self:nvim())
  end)
end

function Provider.nvim(self)
  return self:provide('nvim', function()
    if self.is_running_vim then
      return vim 
    end
    return require('starbase.utils.dummy.nvim')
  end)
end

function Provider.plugin_manager(self)
  return self:provide('plugin_manager', function()
    if self.is_running_vim then
      return require('starbase.plugin.Packer').new(self:nvim())
    end
    return require('starbase.utils.dummy.PluginManager').new()
  end)
end

function Provider.settings_builder(self)
  return self:provide('settings_builder', function()
    return require('starbase.settings.Builder').new()
  end)
end

function Provider.settings_file_name(self)
  return self:provide('settings_file_name', function()
    return 'starbase.json'
  end)
end

function Provider.statusline(self)
  return self:provide('statusline', function()
    return require('starbase.statusline.Lualine').new(
      self:plugin_manager()
    )
  end)
end

function Provider.theme(self)
  return self:provide('theme', function()
    return require('starbase.theme.Palenight').new(
      self:nvim(),
      self:plugin_manager(),
      self:statusline()
    )
  end)
end

function Provider.treesitter(self)
  return self:provide('treesitter', function() 
    return require('starbase.treesitter.Treesitter').new(
      self:plugin_manager()
    )
  end)
end

function Provider.editor_aspect(self)
  return self:provide('editor_aspect', function()
    return require('starbase.aspects.Editor').new(
      self:nvim(),
      self:mapper(),
      self:theme(),
      self:statusline()
    )
  end)
end

function Provider.provide(self, id, provider_fn)
  if self.instances[id] ~= nil then
    return self.instances[id].instance
  end

  local instance = provider_fn()
  self.instances[id] = {
    instance = instance,
  }

  return self.instances[id].instance
end

return Provider
