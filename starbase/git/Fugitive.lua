local Fugitive = {}
Fugitive.__index = Fugitive

function Fugitive.new(mapper, plugin_manager)
  return setmetatable({
    mapper = mapper,
    plugin_manager = plugin_manager,
  }, Fugitive)
end

function Fugitive.configure(self)
  self.plugin_manager:add_dependency('tpope/vim-fugitive')
  self.plugin_manager:add_dependency('airblade/vim-gitgutter')

  self.mapper:spacemap('gs', '<cmd>Git<CR>', 'git status')
  self.mapper:spacemap('gc', '<cmd>Git commit<CR>', 'git commit')
  self.mapper:spacemap('gb', '<cmd>Git blame<CR>', 'git blame')
  self.mapper:spacemap('gf', '<cmd>GFiles?<CR>', 'git changed files')
  self.mapper:spacemap('gp', '<cmd>GitGutterPrevHunk<CR>', 'previous modified hunk')
  self.mapper:spacemap('gn', '<cmd>GitGutterNextHunk<CR>', 'next modified hunk')
end

return Fugitive
