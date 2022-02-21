Editor = {}
Editor.__index = Editor

function Editor.new(nvim, mapper)
  return setmetatable({nvim = nvim, mapper = mapper}, Editor)
end

function Editor.configure(self)
  self:setup_nvim()
  self:setup_mappings()

  self:export_file_def()
end

function Editor.setup_nvim(self)
  if (self.nvim.fn.exists('+termguicolors')) then
    self.nvim.o['termguicolors'] = true
  end

  self.nvim.o.completeopt = 'menuone,noselect'
  self.nvim.o.foldlevelstart = 90
  self.nvim.o.hidden = true
  self.nvim.o.shortmess = self.nvim.o.shortmess .. "c"
  self.nvim.o.showtabline = 1
  self.nvim.o.updatetime = 1000
  self.nvim.wo.number = true
  self.nvim.wo.relativenumber = true
  self.nvim.wo.signcolumn = 'yes'
  self.nvim.wo.colorcolumn = '80'

  local indent_size = 4
  self.nvim.bo.shiftwidth = indent_size
  self.nvim.bo.smartindent = true
  self.nvim.bo.tabstop = indent_size
  self.nvim.bo.softtabstop = indent_size

  self.nvim.g.netrw_banner = 0
end

function Editor.setup_mappings(self)
  self.mapper:spacemap(
    'w', '<cmd>bd<CR>', 
    'close the current buffer'
  )

  self.mapper:spacemap(
    'fe', '<cmd>Explore<CR>', 
    'open the file explorer'
  )

  self.mapper:spacemap(
    'fr', self:export_file_def(), 
    'copy the current file and line definition to the clipboard'
  )

  self.mapper:spacemap(
    'nt', '<cmd>set norelativenumber!<CR>',
    'toggle relative line number option'
  )

  self.mapper:map('<C-c>', '<ESC>', 'escape using control c', 'i')
  self.mapper:leadermap('y', '"+y', 'yank to clipboard')
  self.mapper:leadermap('p', '"+p', 'paste from clipboard')

  self.mapper:spacemap('tt', '<cmd>tabnew<CR>', 'open a new tab')
  self.mapper:spacemap('tj', '<cmd>tabn<CR>', 'go to the next tab')
  self.mapper:spacemap('tk', '<cmd>tabp<CR>', 'go to the previous tab')
  self.mapper:spacemap('tw', '<cmd>tabclose<CR>', 'closes the current tab')
end

function Editor.export_file_def(self)
  return {
    'file_def',
    function()
      local file_reference = self.nvim.fn.expand('%') .. ':' .. self.nvim.fn.line('.')
      self.nvim.fn.setreg('+', file_reference)
      print('"' .. file_reference .. '" copied to clipboard')
    end,
  } 
end

return Editor
