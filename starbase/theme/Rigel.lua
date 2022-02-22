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
  self.plugin_manager:add_dependency('Rigellute/rigel', self:configure_theme())
  self.statusline:set_theme('rigel', {'airline', 'lightline'})
end

function Rigel.configure_theme(self)
  return function()
    self.plugin_manager:run(function()
      self.nvim.cmd 'colorscheme rigel'
    end)
  end
end

return Rigel
