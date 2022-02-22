PluginManager = {}
PluginManager.__index = PluginManager

function PluginManager.new()
  return setmetatable({}, PluginManager)
end

function PluginManager.evaluate(self)
end

function PluginManager.add_dependency(self, plugin_name, config, opts)
  return self
end

return PluginManager
