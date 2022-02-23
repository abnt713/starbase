return function()
  -- Used to export functionality beyond class scope.
  finalfrontier = {}

  local provider = nil
  local ok = pcall(function()
    provider = require('starbase.custom.Provider'):new()
  end)

  if not ok then
    provider = require('starbase.app.Provider'):new()
  end

  local starbase = provider:starbase()
  starbase:init()
end
