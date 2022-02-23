-- This one is a custom provider. Use this instance to override any DI decision.
-- It is important to place this file in the import path "starbase.custom.Provider".
-- If no file is found in this path, the application will use the default Provider.
local ParentProvider = require('starbase.app.Provider')
local Provider = ParentProvider:new()

-- This method overrides the default layers configuration and adds another layer with
-- extra vim configurations and... Tetris, why not :D
-- This is just an example on how to override all the standard structures through
-- provider overriding. Notice that resolving dependencies also work here.
-- function Provider.layers(self)
--   local nvim = self:nvim()
--   local plugin_manager = self:plugin_manager()
--   local extra_layer = {
--     configure = function()
--       nvim.opt.colorcolumn = '120'
--       plugin_manager:add_dependency('alec-gibson/nvim-tetris')
--     end
--   }
--   local override_layers = ParentProvider.layers(self)
--   table.insert(override_layers, extra_layer)
--   return override_layers
-- end

-- Another example: this method overrides the default theme setting and uses the Rigel theme.
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
