local PluginManager = {}
PluginManager.__index = PluginManager

function PluginManager.new()
  return setmetatable({}, PluginManager)
end

function PluginManager.configure()
end

function PluginManager.evaluate()
end

function PluginManager.add_dependency(self)
  return self
end

return PluginManager
