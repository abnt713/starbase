local Provider = {}
Provider.__index = Provider

function Provider.new(self, nvim)
  return setmetatable({
    is_running_vim = (nvim ~= nil),
    instances = {},
  }, self)
end

function Provider.starbase(self)
  return self:provide('starbase', function()
    return require('starbase.app.Starbase').new(
      self:plugin_manager(),
      self:stages(),
      self:tools()
    )
  end)
end

function Provider.autocomplete(self)
  return self:provide('autocomplete', function()
    return require('starbase.autocomplete.Cmp').new(
      self:nvim(),
      self:plugin_manager()
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
    return require('starbase.filetree.NERDTree').new(
      self:mapper(),
      self:nvim(),
      self:plugin_manager()
    )
  end)
end

function Provider.fuzzy(self)
  return self:provide('fuzzy', function()
    return require('starbase.fuzzy.Telescope').new(self:mapper(), self:plugin_manager())
  end)
end


function Provider.git(self)
  return self:provide('git', function()
    return require('starbase.git.Fugitive').new(
      self:starbase_settings(),
      self:mapper(),
      self:plugin_manager()
    )
  end)
end

function Provider.go_settings(self)
  return self:provide('go_settings', function()
    return require('starbase.settings.Go').new(self:project_settings())
  end)
end

function Provider.stages(self)
  return self:provide('layers', function ()
    return {
      self:editor(),
      require('starbase.stages.Go'):new(
        self:go_settings(),
        self:linter(),
        self:lsp(),
        self:plugin_manager(),
        self:starbase_settings()
      ),
      require('starbase.stages.Lua'):new(
        self:linter(),
        self:lsp(),
        self:nvim(),
        self:plugin_manager(),
        self:starbase_settings()
      ),
      require('starbase.stages.Python'):new(
        self:file_system(),
        self:linter(),
        self:lsp(),
        self:starbase_settings()
      )
    }
  end)
end

function Provider.linter(self)
  return self:provide('linter', function()
    return require('starbase.linter.NvimLint').new(
      self:nvim(),
      self:plugin_manager(),
      self:starbase_settings()
    )
  end)
end

function Provider.lsp(self)
  return self:provide('lsp', function()
    return require('starbase.lsp.LSP').new(
      self:lsp_capabilities(),
      self:mapper(),
      self:nvim(),
      self:plugin_manager(),
      self:starbase_settings()
    )
  end)
end

function Provider.lsp_capabilities(self)
  return self:provide('lsp_capabilities', function()
    return self:autocomplete()
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

function Provider.packer(self)
  return self:provide('packer', function()
    return require('starbase.plugin.Packer').new(self:nvim())
  end)
end

function Provider.plugin_manager(self)
  return self:provide('plugin_manager', function()
    if self.is_running_vim then
      return require('starbase.plugin.PackerInstaller').new(self:nvim(), self:packer())
    end
    return require('starbase.utils.dummy.PluginManager').new()
  end)
end

function Provider.project_settings(self)
  return self:provide('project_settings', function()
    local settings_builder = self:settings_builder()
    local defaults = settings_builder:from_requirement('starbase.defaults.projectcfg')
    return require('starbase.settings.Project').new(
      self:codec(),
      defaults,
      self:file_system(),
      self:settings_builder(),
      self:starbase_settings()
    )
  end)
end

function Provider.settings_builder(self)
  return self:provide('settings_builder', function()
    return require('starbase.settings.Settings').new({})
  end)
end

function Provider.starbase_settings(self)
  return self:provide('starbase_settings', function()
    local settings_builder = self:settings_builder()

    local defaults = settings_builder:from_requirement('starbase.defaults.starbasecfg')
    return settings_builder:from_requirement('starbase.custom.config', defaults)
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
      self:starbase_settings(),
      self:nvim(),
      self:plugin_manager(),
      self:statusline()
    )
  end)
end

function Provider.tools(self)
  return self:provide('tools', function()
    return {
      -- statusbar, theme and similars.
      self:theme(),
      self:statusline(),

      -- Concepts from the editing world.
      self:autocomplete(),
      self:filetree(),
      self:lsp(),
      self:treesitter(),
      self:linter(),
      self:fuzzy(),

      -- Versioning
      self:git(),
    }
  end)
end

function Provider.treesitter(self)
  return self:provide('treesitter', function()
    return require('starbase.treesitter.Treesitter').new(
      self:plugin_manager()
    )
  end)
end

function Provider.editor(self)
  return self:provide('editor', function()
    return require('starbase.stages.Editor').new(
      self:starbase_settings(),
      self:nvim(),
      self:mapper(),
      self:plugin_manager()
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
