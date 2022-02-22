local Lualine = {}
Lualine.__index = Lualine

function Lualine.new(plugin_manager)
  return setmetatable({
    plugin_manager = plugin_manager,

    theme = nil,
  }, Lualine)
end

function Lualine.set_theme(self, theme, supported)
  for _, v in pairs(supported) do
    if v == 'lualine' then
      self.theme = theme
      return
    end
  end
end

function Lualine.configure(self)
  local lualine_dep = self.plugin_manager:add_dependency(
    'hoob3rt/lualine.nvim',
    self:setup_lualine()
  )

  lualine_dep:add_dependency('kyazdani42/nvim-web-devicons')
end

function Lualine.setup_lualine(self)
  return function()
    local lualine = self.plugin_manager:require('lualine')
    if not lualine then return end

    -- local lualine = require('lualine')
    lualine.setup {
      options = {
        icons_enabled = true,
        theme = self.theme or nil,
        component_separators = {'', ''},
        section_separators = {'', ''},
        disabled_filetypes = {}
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    }
  end
end

return Lualine
