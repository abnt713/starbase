local NvimLint = {}
NvimLint.__index = NvimLint

function NvimLint.new(nvim, plugin_manager, starbase_settings)
  return setmetatable({
    nvim = nvim,
    plugin_manager = plugin_manager,
    starbase_settings = starbase_settings,

    linters_by_ft = {}
  }, NvimLint)
end

function NvimLint.set_linters_for_ft(self, ft, linters)
  self.linters_by_ft[ft] = linters
end

function NvimLint.configure(self)
  self.plugin_manager:add_dependency('mfussenegger/nvim-lint', self:setup_plugin())
end

function NvimLint.setup_plugin(self)
  return function()
    local lint = self.plugin_manager:require('lint')
    if not lint then return end

    for ft, settings in pairs(self.linters_by_ft) do
      lint.linters_by_ft[ft] = settings
    end

    lint.linters_by_ft['markdown'] = nil

    self.nvim.api.nvim_exec([[
      au BufWritePost * lua require('lint').try_lint()
      au BufWinEnter * lua require('lint').try_lint()
    ]], false)
  end
end

return NvimLint
