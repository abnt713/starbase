Treesitter = {}
Treesitter.__index = Treesitter

function Treesitter.new(plugin_manager)
  return setmetatable({
    plugin_manager = plugin_manager,
  }, Treesitter)
end

function Treesitter.configure(self)
  local treesitter_dep = self.plugin_manager:add_dependency(
    'nvim-treesitter/nvim-treesitter', 
    self:setup(), 
    {run = function() vim.cmd 'TSUpdate' end}
  )
  self.plugin_manager:add_dependency('nvim-treesitter/playground')
end

function Treesitter.setup(self)
  return function()
    local tsmod = self.plugin_manager:require('nvim-treesitter.configs')
    if not tsmod then return end
    tsmod.setup({
      highlight = { enable = true },
      indent = {
        enable = false
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      }
    })
  end
end

return Treesitter
