Palenight = {}
Palenight.__index = Palenight

function Palenight.new(nvim, plugin_manager, statusline)
  return setmetatable({
    nvim = nvim,
    plugin_manager = plugin_manager,
    statusline = statusline,
  }, Palenight)
end

function Palenight.apply(self)
  self.plugin_manager:add_dependency('Cybolic/palenight.vim')
  self.nvim.o.background = 'dark'
  self.nvim.wo.cursorline = true

  self.nvim.cmd 'colorscheme palenight'
  self.statusline:set_theme('palenight', {'lualine'})
end

return Palenight
