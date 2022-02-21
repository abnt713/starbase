Builder = {}
Builder.__index = Builder

function Builder.new()
  return setmetatable({}, Builder)
end

function Builder.settings_from_key(self, key, contents)
  if key == 'go' then
    return self:go_settings(contents)
  end

  return nil
end

function Builder.go_settings(self, contents)
  return require('starbase.settings.Go').new(contents)
end

return Builder
