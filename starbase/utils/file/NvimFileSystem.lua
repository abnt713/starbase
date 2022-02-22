NvimFileSystem = {}
NvimFileSystem.__index = NvimFileSystem

function NvimFileSystem.new(nvim)
  return setmetatable({
    nvim = nvim,
  }, NvimFileSystem)
end

function NvimFileSystem.path_from_cwd(self, filename)
  local cwd = self.nvim.fn.getcwd()
  return cwd .. '/' .. filename
end

function NvimFileSystem.exists(self, path)
  return self.nvim.fn.filereadable(path) == 1
end

function NvimFileSystem.read(self, path)
  return self.nvim.fn.readfile(path)
end

return NvimFileSystem
