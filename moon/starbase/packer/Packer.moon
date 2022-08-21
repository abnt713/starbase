class Packer
  new: (nvim) =>
    @nvim = nvim
    @plugins = {}
    @require 'wbthomason/packer.nvim'

  require: (name) =>
    dep = require('starbase.packer.Plugin') @nvim, name
    table.insert @plugins, dep
    dep

  apply: =>
    result = require('packer').startup (use) ->
      for _, dep in pairs @plugins
        use dep\statement!

    for _, dep in pairs @plugins
      dep\call_posthook!
    result

Packer