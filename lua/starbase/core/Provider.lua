local Provider = {}
Provider.__index = Provider

function Provider.new(self, nvim)
  return setmetatable({
    is_running_vim = (nvim ~= nil),
    instances = {},
  }, self)
end

-- starbase provides the main application.
function Provider.starbase(self)
  return self:provide('starbase', function()
    return require('starbase.core.Starbase').new(
      self:plugin_manager(),
      self:post_hooks(),
      self:stages(),
      self:tools()
    )
  end)
end

-- stages provides all application stages.
function Provider.stages(self)
  return self:provide('layers', function ()
    return {
      self:editor_stage(),
      self:cpp_stage(),
      self:go_stage(),
      require('starbase.core.stages.Lua'):new(
        self:linter(),
        self:lsp(),
        self:nvim(),
        self:plugin_manager(),
        self:starbase_settings()
      ),
      require('starbase.core.stages.Python'):new(
        self:file_system(),
        self:linter(),
        self:lsp(),
        self:starbase_settings()
      ),
      self:rust_stage(),
      require('starbase.core.stages.Svelte'):new(
        self:plugin_manager()
      )
    }
  end)
end

-- tools provides the application's tools and assets.
function Provider.tools(self)
  return self:provide('tools', function()
    return {
      -- statusbar, theme and similars.
      self:theme(),
      self:statusline(),

      -- Concepts from the editing and coding world.
      self:autocomplete(),
      self:debug(),
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

-- post_hooks contains all components which responds to post hooks.
function Provider.post_hooks()
  return {}
end

-- debug provides the debug layer of the application.
function Provider.debug(self)
  return self:provide('debug', function ()
    return require('starbase.core.tools.debug.Debug'):new(
      self:mapper(),
      self:plugin_manager()
    )
  end)
end

-- autocomplete provides the autocomplete layer of the application.
function Provider.autocomplete(self)
  return self:provide('autocomplete', function()
    return require('starbase.core.tools.autocomplete.Cmp').new(
      self:nvim(),
      self:plugin_manager()
    )
  end)
end

-- codec provides the structure capable of encoding and decoding data.
function Provider.codec(self)
  return self:provide('codec', function()
    return require('starbase.core.utils.codec.NvimJsonCodec').new(self:nvim())
  end)
end

-- file_system provides a file system abstraction to work with.
function Provider.file_system(self)
  return self:provide('fs', function()
    return require('starbase.core.utils.file.NvimFileSystem').new(self:nvim())
  end)
end

-- filetree provides the filetree component.
function Provider.filetree(self)
  return self:provide('filetree', function()
    return require('starbase.core.tools.filetree.NERDTree').new(
      self:mapper(),
      self:nvim(),
      self:plugin_manager()
    )
  end)
end

-- fuzzy provides the component related to fuzzy finding needs.
function Provider.fuzzy(self)
  return self:provide('fuzzy', function()
    return require('starbase.core.tools.fuzzy.Telescope').new(self:mapper(), self:plugin_manager())
  end)
end

-- git provides the Git component.
function Provider.git(self)
  return self:provide('git', function()
    return require('starbase.core.tools.git.Fugitive').new(
      self:starbase_settings(),
      self:mapper(),
      self:plugin_manager()
    )
  end)
end

-- go_settings provides the component which can provide go settings.
function Provider.go_settings(self)
  return self:provide('go_settings', function()
    return require('starbase.core.tools.settings.Go').new(self:project_settings())
  end)
end

-- editor provides the component which can apply base settings.
function Provider.editor_stage(self)
  return self:provide('editor', function()
    return require('starbase.core.stages.Editor').new(
      self:starbase_settings(),
      self:nvim(),
      self:mapper(),
      self:plugin_manager()
    )
  end)
end

function Provider.cpp_stage(self)
  return self:provide('cpp_stage', function ()
    return require('starbase.core.stages.Cpp'):new(
      self:lsp(),
      self:starbase_settings()
    )
  end)
end

-- go_stage is the application stage focused on Go support.
function Provider.go_stage(self)
  return self:provide('go_stage', function ()
    return require('starbase.core.stages.Go'):new(
        self:go_settings(),
        self:linter(),
        self:lsp(),
        self:mapper(),
        self:nvim(),
        self:plugin_manager(),
        self:starbase_settings()
      )
  end)
end

function Provider.rust_stage(self)
  return self:provide('rust_stage', function ()
    return require('starbase.core.stages.Rust'):new(
      self:lsp(),
      self:starbase_settings()
    )
  end)
end

-- linter provides the linter component.
function Provider.linter(self)
  return self:provide('linter', function()
    return require('starbase.core.tools.linter.NvimLint').new(
      self:nvim(),
      self:plugin_manager(),
      self:starbase_settings()
    )
  end)
end

-- lsp provides the LSP component.
function Provider.lsp(self)
  return self:provide('lsp', function()
    return require('starbase.core.tools.lsp.LSP').new(
      self:lsp_capabilities(),
      self:mapper(),
      self:nvim(),
      self:plugin_manager(),
      self:starbase_settings()
    )
  end)
end

-- lsp_capabilities provides all components which can provide LSP capabilities.
function Provider.lsp_capabilities(self)
  return self:provide('lsp_capabilities', function()
    return self:autocomplete()
  end)
end

-- mapper provides the mapping abstraction.
function Provider.mapper(self)
  return self:provide('mapper', function()
    return require('starbase.core.utils.map.NvimMapper').new(self:nvim())
  end)
end

-- nvim provides the "vim" global as a local dependency.
function Provider.nvim(self)
  return self:provide('nvim', function()
    if self.is_running_vim then
      return vim
    end
    return require('starbase.core.utils.dummy.nvim')
  end)
end

-- packer provides the Packer plugin/package manager.
function Provider.packer(self)
  return self:provide('packer', function()
    return require('starbase.core.tools.plugin.Packer').new(self:nvim())
  end)
end

-- plugin_manager provides the application plugin_manager.
function Provider.plugin_manager(self)
  return self:provide('plugin_manager', function()
    if self.is_running_vim then
      return require('starbase.core.tools.plugin.PackerInstaller').new(self:nvim(), self:packer())
    end
    return require('starbase.core.utils.dummy.PluginManager').new()
  end)
end

-- project_settings provides the component which can parse and provide the
-- project settings.
function Provider.project_settings(self)
  return self:provide('project_settings', function()
    local settings_builder = self:settings_builder()
    local defaults = settings_builder:from_requirement('starbase.core.defaults.projectcfg')
    return require('starbase.core.tools.settings.Project').new(
      self:codec(),
      defaults,
      self:file_system(),
      self:settings_builder(),
      self:starbase_settings()
    )
  end)
end

-- settings_builder provides the component which can build a set of settings.
function Provider.settings_builder(self)
  return self:provide('settings_builder', function()
    return require('starbase.core.tools.settings.Settings').new({})
  end)
end

-- starbase_settings provides the component which can parse and provide the
-- whole starbase settings.
function Provider.starbase_settings(self)
  return self:provide('starbase_settings', function()
    local settings_builder = self:settings_builder()

    local defaults = settings_builder:from_requirement('starbase.core.defaults.starbasecfg')
    return settings_builder:from_requirement('starbase.override.config', defaults)
  end)
end

-- statusline provides the statusline component.
function Provider.statusline(self)
  return self:provide('statusline', function()
    return require('starbase.core.tools.statusline.Lualine').new(
      self:plugin_manager()
    )
  end)
end

-- theme provides the visual theme component.
function Provider.theme(self)
  return self:provide('theme', function()
    return require('starbase.core.tools.theme.Palenight').new(
      self:starbase_settings(),
      self:nvim(),
      self:plugin_manager(),
      self:statusline()
    )
  end)
end


-- treesitter provides the component which configures the neovim TS.
function Provider.treesitter(self)
  return self:provide('treesitter', function()
    return require('starbase.core.tools.treesitter.Treesitter').new(
      self:plugin_manager()
    )
  end)
end


-- provide register a function as a provider function and binds it to an id.
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