local PluginManager = {}
PluginManager.__index = PluginManager

function PluginManager.new()
  return setmetatable({
    dependencies = {},
    total_plugins = 0
  }, PluginManager)
end

function PluginManager.configure()
  print('Starbase v0.0.0\n~Running in local mode~\n')
  print('Listing all required dependencies by your base...')
end

function PluginManager.evaluate(self)
  print('Your base requires the following plugins:')
  print(table.concat(self.dependencies, '\n'))
  print('\nTotal required plugins: ', self.total_plugins)
end

function PluginManager.add_dependency(self, dependency)
  table.insert(self.dependencies, '\t- ' .. dependency)
  self.total_plugins = self.total_plugins + 1
  return self
end

return PluginManager
