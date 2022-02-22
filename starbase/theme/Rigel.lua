Rigel = {}
Rigel.__index = Rigel

function Rigel.new(nvim, plugin_manager, statusline)
  return setmetatable({
    nvim = nvim,
    plugin_manager = plugin_manager,
    statusline = statusline,
  }, Rigel)
end

function Rigel.apply(self)
  self.plugin_manager:add_dependency('Rigellute/rigel', self:setup())
end

function Rigel.setup(self)
  return function()
    self.nvim.cmd 'colorscheme rigel'
    self.statusline:set_theme('rigel', {'airline', 'lightline'})
  end
end

return Rigel
