local Project = {}
Project.__index = Project

function Project.new(codec, defaults, fs, settings_builder, starbase_settings)
  local proj_settings = setmetatable({
    codec = codec,
    defaults = defaults,
    fs = fs,
    settings_builder = settings_builder,
    starbase_settings = starbase_settings,

    settings = nil,
  }, Project)

  proj_settings:parse()
  return proj_settings
end

function Project.parse(self)
  local project_config_filename = self.starbase_settings:get('project.file')
  local project_filename = self.fs:path_from_cwd(project_config_filename)
  if not self.fs:exists(project_filename) then
    self.settings = self.settings_builder:from_contents({}, self.defaults)
    return
  end

  -- TODO: Improve error handling.
  local contents = self.fs:read(project_filename)

  -- TODO: Improve error handling.
  local json_content = self.codec:decode(contents)
  self.settings = self.settings_builder:from_contents(json_content, self.defaults)
end

function Project.get(self, setting)
  if not self.settings then return nil end
  return self.settings:get(setting)
end

return Project
