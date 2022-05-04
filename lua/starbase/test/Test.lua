local Test = {}
Test.__index = Test

function Test.new(self, handlers_by_ft, nvim)
  return setmetatable({
    handlers_by_ft = handlers_by_ft,
    nvim = nvim,
  }, self)
end

function Test.run(self)
  local ft = self.nvim.api.nvim_buf_get_option(0, 'filetype')
  local handler = self.handlers_by_ft[ft]
  if not handler then
    print("No handlers for filetype", ft)
    return
  end
  return handler:run_for_ft(ft)
end

return Test
