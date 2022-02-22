NvimJsonCodec = {}
NvimJsonCodec.__index = NvimJsonCodec

function NvimJsonCodec.new(nvim)
  return setmetatable({
    nvim = nvim,
  }, NvimJsonCodec)
end

function NvimJsonCodec.decode(self, content)
  return self.nvim.fn.json_decode(content)
end

return NvimJsonCodec
