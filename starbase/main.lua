return function()
  -- Used to export functionality beyond class scope.
  finalfrontier = {}

  local provider = require('starbase.app.Provider').new()

  local settings_file = provider:settings_file_name()
  local nvim = provider:nvim()
  local builder = provider:settings_builder()
  local fs = provider:file_system(nvim)
  local codec = provider:codec(nvim) 

  local settings = require('starbase.settings.ProjectSettings').new(
    settings_file,
    builder,
    fs,
    codec
  )

  local mapper = provider:mapper(nvim)
  local editor_aspect = provider:editor_aspect(nvim, mapper)

  local base = require('starbase.app.Starbase').new(
    editor_aspect
  )
  base:init()
end
