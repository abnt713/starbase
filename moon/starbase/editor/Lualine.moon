class Lualine
  theme: (target, theme) =>
    if target != 'lualine' then return
    @_theme = theme

  apply: (nvim, plugins, maps) =>
    with plugins\require 'hoob3rt/lualine.nvim'
      \post_hook(@_setup_lualine!)

  _setup_lualine: =>
    ->
      require('lualine').setup {
        options: {
          icons_enabled: true,
          theme: @_theme or nil,
          component_separators: {'', ''},
          section_separators: {'', ''},
          disabled_filetypes: {}
        },
        sections: {
          lualine_a: {'mode'},
          lualine_b: {'branch'},
          lualine_c: {'filename'},
          lualine_x: {'encoding', 'fileformat', 'filetype'},
          lualine_y: {'progress'},
          lualine_z: {'location'}
        },
        inactive_sections: {
          lualine_a: {},
          lualine_b: {},
          lualine_c: {'filename'},
          lualine_x: {'location'},
          lualine_y: {},
          lualine_z: {}
        },
        tabline: {},
        extensions: {}
      }
  
Lualine