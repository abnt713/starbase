local NvimLint = {}
NvimLint.__index = NvimLint

function NvimLint.new(nvim, plugin_manager)
  return setmetatable({
    nvim = nvim,
    plugin_manager = plugin_manager,
  }, NvimLint)
end

function NvimLint.configure(self)
  self.plugin_manager:add_dependency('mfussenegger/nvim-lint', self:setup_plugin())
end

function NvimLint.setup_plugin(self)
  return function()
    local lint = self.plugin_manager:require('lint')
    if not lint then return end

    lint.linters_by_ft = {
      go = {'revive'},
      lua = {'luacheck'},
    }
    self.nvim.api.nvim_exec([[
      au BufWritePost * lua require('lint').try_lint()
      au BufWinEnter * lua require('lint').try_lint()
    ]], false)
  end
end

return NvimLint
