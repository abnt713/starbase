local NvimLint = {}
NvimLint.__index = NvimLint

function NvimLint.new(nvim, plugin_manager, starbase_settings)
  return setmetatable({
    nvim = nvim,
    plugin_manager = plugin_manager,
    starbase_settings = starbase_settings,
  }, NvimLint)
end

function NvimLint.configure(self)
  self.plugin_manager:add_dependency('mfussenegger/nvim-lint', self:setup_plugin())
end

function NvimLint.setup_plugin(self)
  return function()
    local lint = self.plugin_manager:require('lint')
    if not lint then return end

    -- TODO: Improve layer configuration here
    if self.starbase_settings:get('layers.go.enabled') then
      lint.linters_by_ft.go = self.starbase_settings:get('layers.go.linters')
    end

    if self.starbase_settings:get('layers.lua.enabled') then
      lint.linters_by_ft.lua = self.starbase_settings:get('layers.lua.linters')
    end
    self.nvim.api.nvim_exec([[
      au BufWritePost * lua require('lint').try_lint()
      au BufWinEnter * lua require('lint').try_lint()
    ]], false)
  end
end

return NvimLint
