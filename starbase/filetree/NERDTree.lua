local NERDTree = {}
NERDTree.__index = NERDTree

function NERDTree.new(plugin_manager, mapper)
  return setmetatable({
    plugin_manager = plugin_manager,
    mapper = mapper,
  }, NERDTree)
end

function NERDTree.configure(self)
  local nt_dep = self.plugin_manager:add_dependency('preservim/nerdtree')
  nt_dep:add_dependency('ryanoasis/vim-devicons')

  self:apply_mappings()
end

function NERDTree.apply_mappings(self)
  self.mapper:spacemap('ft', '<cmd>NERDTreeToggle<CR>', 'open NERDTree')
end

return NERDTree
