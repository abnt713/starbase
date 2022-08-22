(opts, proj) ->
  cfg = require('starbase.config.Config') opts
  pcfg = require('starbase.config.Config') proj

  nvim = vim
  pm = require('starbase.packer.Packer') nvim
  maps = require('starbase.maps.Maps') nvim

  lsp = require('starbase.editor.LSP')!
  line = require('starbase.editor.Lualine')!
  lint = require('starbase.editor.NvimLint')!
  steps = {
    require('starbase.editor.Editor')!,
    require('starbase.editor.Cmp')(lsp),
    require('starbase.editor.Treesitter')!,
    require('starbase.editor.Telescope')!,
    require('starbase.editor.NERDTree')!,

    require('starbase.tech.Debug')!,
    require('starbase.tech.Fugitive')!,
    require('starbase.tech.Moonscript')!,
    require('starbase.tech.Go')(pcfg, lsp),

    require('starbase.theme.Palenight')!,

    lsp,
    line,
    lint,
  }

  for _, step in pairs steps
    if step.id == nil or cfg\get('steps.' .. step\id! .. '.enabled', true)
      step\apply nvim, pm, maps

  pm\apply!
