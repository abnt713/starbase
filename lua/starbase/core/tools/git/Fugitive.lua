local Fugitive = {}
Fugitive.__index = Fugitive

function Fugitive.new(base_settings, mapper, plugin_manager)
  return setmetatable({
    base_settings = base_settings,
    mapper = mapper,
    plugin_manager = plugin_manager,
  }, Fugitive)
end

function Fugitive.configure(self)
  self.plugin_manager:add_dependency('tpope/vim-fugitive')
  self.mapper:spacemap('gs', '<cmd>Git<CR>', 'git status')
  self.mapper:spacemap('gc', '<cmd>Git commit<CR>', 'git commit')
  self.mapper:spacemap('gb', '<cmd>Git blame<CR>', 'git blame')

  if self.base_settings:get('editor.gitgutter.enabled') then
    self.plugin_manager:add_dependency('airblade/vim-gitgutter')
    self.mapper:spacemap('gp', '<cmd>GitGutterPrevHunk<CR>', 'previous modified hunk')
    self.mapper:spacemap('gn', '<cmd>GitGutterNextHunk<CR>', 'next modified hunk')
  end

end

return Fugitive
