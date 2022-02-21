ProjectSettings = {}
ProjectSettings.__index = ProjectSettings

function ProjectSettings.new(settings_file, builder, fs, codec)
  proj_settings = setmetatable({
    settings_file = settings_file,
    builder = builder,
    fs = fs,
    codec = codec,
    settings = {},
  }, ProjectSettings)

  proj_settings:parse()
  return proj_settings
end

function ProjectSettings.parse(self)
  local project_file_name = self.fs:path_from_cwd(self.settings_file)
  if not self.fs:exists(project_file_name) then
    return
  end

  -- TODO: Improve error handling.
  local contents = nil
  contents = self.fs:read(project_file_name)

  -- TODO: Improve error handling.
  local json_content = nil
  json_content = self.codec:decode(contents)

  for k, v in pairs(json_content) do 
    project_settings = self.builder:settings_from_key(k, v)
    if project_settings ~= nil then
      self.settings[k] = project_settings
    end
  end
end

function ProjectSettings.settings_exists(self, project_type)
  return self.settings[project_type] ~= nil
end

function ProjectSettings.settings_for(self, project_type)
  return self.settings[project_type]
end

return ProjectSettings
