Starbase = {}
Starbase.__index = Starbase

function Starbase.new(editor, filetree, plugin_manager, treesitter)
  return setmetatable({
    editor = editor,
    filetree = filetree,
    plugin_manager = plugin_manager,
    treesitter = treesitter,
  }, Starbase)
end

function Starbase.init(self)
  self.editor:configure()
  self.filetree:configure()
  self.treesitter:configure()

  self.plugin_manager:evaluate()
end

return Starbase
