Starbase = {}
Starbase.__index = Starbase

function Starbase.new(plugin_manager, editor, filetree)
  return setmetatable({
    plugin_manager = plugin_manager,
    editor = editor,
    filetree = filetree,
  }, Starbase)
end

function Starbase.init(self)
  self.editor:configure()
  self.filetree:configure()

  self.plugin_manager:evaluate()
end

return Starbase
