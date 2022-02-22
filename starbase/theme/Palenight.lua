local Palenight = {}
Palenight.__index = Palenight

function Palenight.new(nvim, plugin_manager, statusline)
  return setmetatable({
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
    self.nvim.wo.cursorline = true
    -- TODO: Get italic from settings
    self.nvim.g.palenight_terminal_italics = 1
    self.plugin_manager:run(function()
      self.nvim.cmd 'colorscheme palenight'
    end)
  end
end

return Palenight
