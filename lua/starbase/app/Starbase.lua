local Starbase = {}
Starbase.__index = Starbase

function Starbase.new(plugin_manager, stages, tools)
  return setmetatable({
    plugin_manager = plugin_manager,
    stages = stages,
    tools = tools,
  }, Starbase)
end

function Starbase.init(self)
  self.plugin_manager:configure()

  for _, stage in pairs(self.stages) do
    stage:configure()
  end

  for _, tool in pairs(self.tools) do
    tool:configure()
  end

  self.plugin_manager:evaluate()
end

return Starbase
