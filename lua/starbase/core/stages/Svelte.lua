local Svelte = {}
Svelte.__index = Svelte

function Svelte.new(self, plugin_manager)
  return setmetatable({
    plugin_manager = plugin_manager,
  }, self)
end

function Svelte.configure(self)
  self.plugin_manager:add_dependency("leafOfTree/vim-svelte-plugin")
end

return Svelte
