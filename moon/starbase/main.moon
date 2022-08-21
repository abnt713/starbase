() ->
  nvim = vim
  pm = require('starbase.packer.Packer') nvim
  maps = require('starbase.maps.Maps') nvim

  lsp = require('starbase.editor.LSP')!
  steps = {
    require('starbase.editor.Editor')!,
    require('starbase.editor.Cmp')(lsp),
    require('starbase.editor.Treesitter')!,
    require('starbase.editor.Telescope')!,
    require('starbase.editor.NERDTree')!,

    require('starbase.tech.Fugitive')!,
    require('starbase.tech.Moonscript')!,

    require('starbase.theme.Palenight')!,

    lsp,
  }

  for _, step in pairs steps
    step\apply nvim, pm, maps

  pm\apply!