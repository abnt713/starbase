Starbase = {}
Starbase.__index = Starbase

function Starbase.new(layers, plugin_manager)
  return setmetatable({
    layers = layers,
    plugin_manager = plugin_manager,
  }, Starbase)
end

function Starbase.init(self)
  for _, layer in pairs(self.layers) do
    layer:configure()
  end

  self.plugin_manager:evaluate()
end

return Starbase
