Project = {}
Project.__index = Project

function Project.new(codec, fs, settings_file)
  proj_settings = setmetatable({
    codec = codec,
    fs = fs,
    settings_file = settings_file,

    settings = {},
  }, Project)

  proj_settings:parse()
  return proj_settings
end

function Project.parse(self)
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

function Project.get(self, setting)
  local value = self.contents
  local setting_value = nil

  for setting_value in string.gmatch(setting, '(%w+)') do 
    if type(value) ~= 'table' then return nil end
    value = value[setting_value]
  end

  return value
end

return Project
