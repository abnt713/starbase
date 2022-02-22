local Settings = {}
Settings.__index = Settings

function Settings.new(default_settings, project_settings)
  return setmetatable({
    default_settings = default_settings,
    project_settings = project_settings,
  }, Settings)
end

function Settings.get(self, setting)
  local project_setting_value = self.project_settings:get(setting)
  if not project_setting_value then
    return self.default_settings:get(setting)
  end

  return project_setting_value
end

return Settings
