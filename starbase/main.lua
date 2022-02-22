return function()
  -- Used to export functionality beyond class scope.
  finalfrontier = {}

  local provider = require('starbase.Provider'):new()
  local starbase = provider:starbase()
  starbase:init()
end
