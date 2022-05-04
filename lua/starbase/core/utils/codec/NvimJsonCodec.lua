local NvimJsonCodec = {}
NvimJsonCodec.__index = NvimJsonCodec

function NvimJsonCodec.new(nvim)
  return setmetatable({
    nvim = nvim,
  }, NvimJsonCodec)
end

function NvimJsonCodec.decode(self, content)
  local results = nil
  pcall(function ()
    results = self.nvim.fn.json_decode(content)
  end)
  return results
end

return NvimJsonCodec
