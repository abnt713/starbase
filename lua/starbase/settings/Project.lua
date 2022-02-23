local Project = {}
Project.__index = Project

function Project.new(codec, fs, settings_builder, settings_filename)
  local proj_settings = setmetatable({
    codec = codec,
    fs = fs,
    settings_builder = settings_builder,
    settings_filename = settings_filename,

    settings = nil,
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
  self.settings = self.settings_builder:from_contents(json_content)
end

function Project.get(self, setting)
  if not self.settings then return nil end
  return self.settings:get(setting)
end

return Project
