Provider = {}
Provider.__index = Provider

function Provider.new()
  return setmetatable({}, Provider)
end

function Provider.codec(self, nvim)
  return require('starbase.codec.NvimJsonCodec').new(nvim)
end

function Provider.file_system(self, nvim)
  return require('starbase.file.NvimFileSystem').new(nvim)
end

function Provider.mapper(self, nvim)
  return require('starbase.map.NvimMapper').new(nvim)
end

function Provider.nvim(self)
  if vim ~= nil then
    return vim 
  end
  return require('starbase.dummy.nvim')
end

function Provider.settings_builder(self)
  return require('starbase.settings.Builder').new()
end

function Provider.settings_file_name(self)
  return 'starbase.json'
end

function Provider.editor_aspect(self, nvim, mapper)
  return require('starbase.aspects.Editor').new(nvim, mapper)
end

return Provider
