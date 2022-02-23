local FallbackSettings = {}
FallbackSettings.__index = FallbackSettings

function FallbackSettings.new(fallback_settings, main_settings)
  return setmetatable({
    fallback_settings = fallback_settings,
    main_settings = main_settings,
  }, FallbackSettings)
end

function FallbackSettings.get(self, setting)
  local project_setting_value = self.main_settings:get(setting)
  if project_setting_value == nil then
    return self.fallback_settings:get(setting)
  end

  return project_setting_value
end

return FallbackSettings
