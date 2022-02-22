-- This one is a custom provider. Use this instance to override any setting.
-- It is important to place this file in the import path "starbase.Provider"
local Provider = require('starbase.app.Provider'):new()

-- This method, for example, overrides the default theme setting and uses the Rigel theme.
-- Uncomment the lines below to override the theme.
-- function Provider.theme(self)
--   return self:provide('theme', function()
--     return require('starbase.theme.Rigel').new(
--       self:nvim(),
--       self:plugin_manager(),
--       self:statusline()
--     )
--   end)
-- end

return Provider
