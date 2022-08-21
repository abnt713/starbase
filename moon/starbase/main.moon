() ->
  nvim = vim
  pm = require('starbase.packer.Packer') nvim
  maps = require('starbase.maps.Maps') nvim

  lsp = require('starbase.editor.LSP')!
  line = require('starbase.editor.Lualine')!
  steps = {
    require('starbase.editor.Editor')!,
    require('starbase.editor.Cmp')(lsp),
    require('starbase.editor.Treesitter')!,
    require('starbase.editor.Telescope')!,
    require('starbase.editor.NERDTree')!,

    require('starbase.tech.Debug')!,
    require('starbase.tech.Fugitive')!,
    require('starbase.tech.Moonscript')!,

    require('starbase.theme.Palenight')!,

    lsp,
    line,
  }

  for _, step in pairs steps
    step\apply nvim, pm, maps

  pm\apply!