class Editor
  apply: (nvim, plugins, maps) =>
    @_nvimcfg nvim

    plugins\require 'gpanders/editorconfig.nvim'
    plugins\require 'christoomey/vim-tmux-navigator'
    plugins\require 'chrisbra/colorizer'
    plugins\require 'tpope/vim-commentary'

    with plugins\require 'lukas-reineke/indent-blankline.nvim'
      \post_hook(@_setup_indentblankline nvim)

    @_mapscfg maps
    
  _nvimcfg: (nvim) =>
    if nvim.fn.exists '+termguicolors'
      nvim.o['termguicolors'] = true

    nvim.o.completeopt = 'menuone,noselect'
    nvim.o.foldlevelstart = 90
    nvim.o.hidden = true
    nvim.o.shortmess = nvim.o.shortmess .. "c"
    nvim.o.showtabline = 1
    nvim.o.updatetime = 1000

    nvim.wo.number = true
    nvim.wo.relativenumber = true
    nvim.wo.signcolumn = 'yes'
    nvim.wo.cursorline = true

    nvim.opt.colorcolumn = '80'

    indent_size = 4
    nvim.bo.shiftwidth = indent_size
    nvim.bo.smartindent = true
    nvim.bo.tabstop = indent_size
    nvim.bo.softtabstop = indent_size

    nvim.g.netrw_banner = 0

  _mapscfg: (maps) =>
    maps\add!\mode('i')\keys('<C-c>')\maps_to('<ESC>')\apply!

    with maps\add!\space!
      \keys('w')\cmd('bd')\apply!
      \keys('fe')\cmd('Explore')\apply!
      \keys('lt')\cmd('set norelativenumber!')\apply!

      \keys('tt')\cmd('tabnew')\apply!
      \keys('tj')\cmd('tabn')\apply!
      \keys('tk')\cmd('tabp')\apply!
      \keys('tw')\cmd('tabclose')\apply!

      \keys('cc')\cmd('ColorToggle')\apply!

  _setup_indentblankline: (nvim) =>
    ->
      nvim.g.indentLine_fileTypeExclude = {
        'checkhealth', 'help', 'lspinfo', 'packer', 'startup'
      }
      require('indent_blankline').setup {
        char: '¦',
        buftype_exclude: {'terminal'}
      }

Editor