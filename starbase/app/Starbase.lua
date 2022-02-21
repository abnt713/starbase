Starbase = {}
Starbase.__index = Starbase

function Starbase.new(editor)
  return setmetatable({
    editor = editor,
  }, Starbase)
end

function Starbase.init(self)
  self.editor:configure()
end

return Starbase
