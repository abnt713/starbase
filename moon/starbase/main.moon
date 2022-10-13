(proj) ->
  req_or = require('starbase.scripts.saferequire')

  cfg = require('starbase.config.Config')(req_or 'starbase.custom.settings', {})
  pcfg = require('starbase.config.Config') proj

  custom_step = req_or 'starbase.custom.step', {apply: -> }
  
  nvim = vim
  pm = require('starbase.packer.Packer') nvim
  maps = require('starbase.maps.Maps') nvim

  lsp = require('starbase.editor.LSP')!
  line = require('starbase.editor.Lualine')!
  lint = require('starbase.editor.NvimLint')(cfg\get 'linter.use_defaults', false)
  steps = {
    require('starbase.editor.Editor')!,
    require('starbase.editor.NvimCmp')(lsp),
    require('starbase.editor.Treesitter')!,
    require('starbase.editor.Telescope')!,
    require('starbase.editor.NvimTree')!,

    require('starbase.tech.Debug')!,
    require('starbase.tech.Fugitive')!,
    require('starbase.tech.Moonscript')!,
    require('starbase.tech.Go')(pcfg, lsp, lint),
    require('starbase.tech.Elm')(lsp),
    require('starbase.tech.Python')(lsp, lint),
    require('starbase.tech.Svelte')(lsp),

    require('starbase.theme.Palenight')!,

    lsp,
    line,
    lint,

    custom_step,
  }

  for _, step in pairs steps
    if step.id == nil or cfg\get('steps.' .. step\id! .. '.enabled', true)
      step\apply nvim, pm, maps

  pm\apply!
