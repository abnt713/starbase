local NERDTree = {}
NERDTree.__index = NERDTree

function NERDTree.new(mapper, plugin_manager)
  return setmetatable({
    mapper = mapper,
    plugin_manager = plugin_manager,
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
