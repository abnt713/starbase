class NvimLint
  new: (usedefaults) =>
    @usedefaults = usedefaults
    @lintersft = {}
  
  id: =>
    'nvim-lint'

  set: (ft, linters) =>
    @lintersft[ft] = linters

  apply: (nvim, plugins, maps) =>
    with plugins\require 'mfussenegger/nvim-lint'
      \post_hook(@_setup_nvim_lint nvim)
  
  _setup_nvim_lint: (nvim) =>
    ->
      lint = require 'lint'
      if not @usedefaults then lint.linters_by_ft = {}
      for ft, linters in pairs @lintersft
        lint.linters_by_ft[ft] = linters
      
      nvim.api.nvim_create_autocmd { 'BufWritePost' }, {
        callback: (->
          require('lint').try_lint!
        ),
      }

NvimLint
