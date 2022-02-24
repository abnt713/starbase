local NERDTree = {}
NERDTree.__index = NERDTree

function NERDTree.new(mapper, nvim, plugin_manager)
  return setmetatable({
    mapper = mapper,
    nvim = nvim,
    plugin_manager = plugin_manager,
  }, NERDTree)
end

function NERDTree.configure(self)
  local dep = self.plugin_manager:add_dependency('preservim/nerdtree')
  dep:add_dependency('ryanoasis/vim-devicons')

  self.nvim.cmd 'let NERDTreeShowLineNumbers = 1'
  self:apply_mappings()
end

function NERDTree.apply_mappings(self)
  self.mapper:spacemap('ft', '<cmd>NERDTreeToggle<CR>', 'open NERDTree')
end

return NERDTree
