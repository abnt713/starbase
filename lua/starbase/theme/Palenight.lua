local Palenight = {}
Palenight.__index = Palenight

function Palenight.new(base_settings, nvim, plugin_manager, statusline)
  return setmetatable({
    base_settings = base_settings,
    nvim = nvim,
    plugin_manager = plugin_manager,
    statusline = statusline,
  }, Palenight)
end

function Palenight.configure(self)
  self.plugin_manager:add_dependency('Cybolic/palenight.vim', self:configure_theme())
  self.statusline:set_theme('palenight', {'lualine'})
end

function Palenight.configure_theme(self)
  return function()
    self.nvim.o.background = 'dark'
    if self.base_settings:get('editor.italics.enabled') then
      self.nvim.g.palenight_terminal_italics = 1
    end
    self.plugin_manager:run(function()
      self.nvim.cmd 'colorscheme palenight'
    end)
  end
end

return Palenight
