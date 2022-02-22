local Telescope = {}
Telescope.__index = Telescope

function Telescope.new(mapper, plugin_manager)
  return setmetatable({
    mapper = mapper,
    plugin_manager = plugin_manager,
  }, Telescope)
end

function Telescope.configure(self)
  local dep = self.plugin_manager:add_dependency(
    'nvim-telescope/telescope.nvim',
    self:setup_telescope()
  )
  dep:add_dependency('nvim-lua/popup.nvim')
  dep:add_dependency('nvim-lua/plenary.nvim')
end

function Telescope.setup_telescope(self)
  return function()
    local telescope = self.plugin_manager:require('telescope')
    if not telescope then return end

    telescope.setup({})
    self.mapper:spacemap('ff', '<cmd>Telescope find_files<CR>')
    self.mapper:spacemap('fg', '<cmd>Telescope live_grep<CR>')
    self.mapper:spacemap('fb', '<cmd>Telescope buffers<CR>')
    self.mapper:spacemap('bb', '<cmd>Telescope buffers<CR>')
    self.mapper:spacemap('fh', '<cmd>Telescope help_tags<CR>')
  end
end

return Telescope
