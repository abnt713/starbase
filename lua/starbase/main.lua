return function()
  -- Here go the globals and dismissable linter warnings -_-
  finalfrontier = {} -- Used to export functionality beyond class scope.
  local nvim = vim -- A local vim reference.
  -- End of all global values and stuff

  local provider = nil
  local ok = pcall(function()
    provider = require('starbase.override.Provider'):new(nvim)
  end)

  if not ok then
    provider = require('starbase.core.Provider'):new(nvim)
  end

  local starbase = provider:starbase()
  starbase:init()
end
