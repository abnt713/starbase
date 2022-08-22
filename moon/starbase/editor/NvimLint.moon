class NvimLint
  new: =>
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
      for ft, linters in pairs @lintersft
        lint.linters_by_ft[ft] = linters
      
      nvim.api.nvim_create_autocmd { 'BufWritePost' }, {
        callback: (->
          require('lint').try_lint!
        ),
      }

NvimLint
