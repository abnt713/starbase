local Debug = {}
Debug.__index = Debug

function Debug.new(self, mapper, plugin_manager)
  return setmetatable({
    mapper = mapper,
    plugin_manager = plugin_manager
  }, self)
end

function Debug.configure(self)
  self.plugin_manager:add_dependency('mfussenegger/nvim-dap', self:setup())
  self:maps()
end

function Debug.setup()
  return function ()
  end
end

function Debug.maps(self)
  self.mapper:leadermap('b', [[<cmd>lua require('dap').toggle_breakpoint()<CR>]])
  self.mapper:leadermap('<s-b>', [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]])
  self.mapper:leadermap('v', [[<cmd>lua require('dap').list_breakpoints(true)<CR>]])
  self.mapper:leadermap('d', [[<cmd>lua require('dap').repl.toggle()<CR>]])
  self.mapper:leadermap('c', [[<cmd>lua require('dap').continue()<CR>]])
end

return Debug