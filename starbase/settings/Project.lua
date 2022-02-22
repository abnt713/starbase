Project = {}
Project.__index = Project

function Project.new(codec, fs, settings_filename)
  proj_settings = setmetatable({
    codec = codec,
    fs = fs,
    settings_filename = settings_filename,

    settings = {},
  }, Project)

  proj_settings:parse()
  return proj_settings
end

function Project.parse(self)
  local project_filename = self.fs:path_from_cwd(self.settings_filename)
  if not self.fs:exists(project_filename) then
    return
  end

  -- TODO: Improve error handling.
  local contents = self.fs:read(project_filename)

  -- TODO: Improve error handling.
  local json_content = self.codec:decode(contents)
  self.contents = json_content
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
