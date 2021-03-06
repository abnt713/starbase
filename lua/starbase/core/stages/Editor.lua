local Editor = {}
Editor.__index = Editor

function Editor.new(base_settings, nvim, mapper, plugin_manager)
  return setmetatable({
    base_settings = base_settings,
    nvim = nvim,
    mapper = mapper,
    plugin_manager = plugin_manager,
  }, Editor)
end

function Editor.configure(self)
  self:setup_nvim()
  self:export_file_def()

  if self.base_settings:get('editor.startup.enabled') then
    local greeter = self.plugin_manager:add_dependency('startup-nvim/startup.nvim', self:setup_greeter())
    greeter:add_dependency('nvim-telescope/telescope.nvim')
    greeter:add_dependency('nvim-lua/plenary.nvim')
  end

  self.plugin_manager:add_dependency('gpanders/editorconfig.nvim')
  self.plugin_manager:add_dependency(
    'lukas-reineke/indent-blankline.nvim',
    self:setup_indentblankline()
  )
  self.plugin_manager:add_dependency('christoomey/vim-tmux-navigator')
  self.plugin_manager:add_dependency('chrisbra/colorizer')
  self.plugin_manager:add_dependency('tpope/vim-commentary')

  self:setup_mappings()
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
  self.nvim.opt.colorcolumn = '80'

  local indent_size = 4
  self.nvim.bo.shiftwidth = indent_size
  self.nvim.bo.smartindent = true
  self.nvim.bo.tabstop = indent_size
  self.nvim.bo.softtabstop = indent_size

  self.nvim.g.netrw_banner = 0

  if self.base_settings:get('editor.cursorline.enabled') then
    self.nvim.wo.cursorline = true
  end

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
    'lt', '<cmd>set norelativenumber!<CR>',
    'toggle relative line number option'
  )

  self.mapper:map('<C-c>', '<ESC>', 'escape using control c', 'i')
  self.mapper:leadermap('y', '"+y', 'yank to clipboard')
  self.mapper:leadermap('p', '"+p', 'paste from clipboard')

  self.mapper:spacemap('tt', '<cmd>tabnew<CR>', 'open a new tab')
  self.mapper:spacemap('tj', '<cmd>tabn<CR>', 'go to the next tab')
  self.mapper:spacemap('tk', '<cmd>tabp<CR>', 'go to the previous tab')
  self.mapper:spacemap('tw', '<cmd>tabclose<CR>', 'closes the current tab')

  self.mapper:spacemap('cc', '<cmd>ColorToggle<CR>', 'colorize color references in buffer')

  local starbase_path = self.nvim.fn.fnamemodify(self.nvim.env.MYVIMRC, ':p:h')

  local starbasecfgfile_path = starbase_path .. '/lua/starbase/core/defaults/starbasecfg.lua'
  local providerfile_path = starbase_path .. '/lua/starbase/core/Provider.lua'

  local customstarbasecfgfile_path = starbase_path .. '/lua/starbase/override/config.lua'
  local customproviderfile_path = starbase_path .. '/lua/starbase/override/Provider.lua'

  self.mapper:spacemap('ce', {
    'open_config_file',
    function ()
      self.nvim.cmd('tabnew')
      self.nvim.cmd('e ' .. starbasecfgfile_path)
      self.nvim.cmd('vs ' .. customstarbasecfgfile_path)
    end,
  }, 'edit the starbase config file')

  self.mapper:spacemap('cp', {
    'open_provider_file',
    function ()
      self.nvim.cmd('tabnew')
      self.nvim.cmd('e ' .. providerfile_path)
      self.nvim.cmd('vs ' .. customproviderfile_path)
    end,
  }, 'edit the starbase provider file')
end

function Editor.export_file_def(self)
  return {
    'file_def',
    function()
      local file_reference = self.nvim.fn.expand('%') .. ':' .. self.nvim.fn.line('.')
      self.nvim.fn.setreg('+', file_reference)
      -- TODO: Abstract dialog
      print('"' .. file_reference .. '" copied to clipboard')
    end,
  }
end

function Editor.setup_greeter(self)
  return function()
    local greeter = self.plugin_manager:require('startup')
    if not greeter then return end

    greeter.setup({theme = self.base_settings:get('editor.startup.theme')})
  end
end

function Editor.setup_indentblankline(self)
  return function()
    local indent_mod = self.plugin_manager:require('indent_blankline')
    if not indent_mod then return end

    self.nvim.g.indentLine_fileTypeExclude = {
      'checkhealth',
      'help',
      'lspinfo',
      'packer',
      'startup',
    }

    indent_mod.setup({
      char = "??",
      buftype_exclude = {"terminal"}
    })
  end
end

return Editor