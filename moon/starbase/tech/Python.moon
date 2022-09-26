class Python
  new: (lsp, linter) =>
    @lsp = lsp
    @linter = linter

  id: =>
    'python'

  apply: =>
    @lsp\add_server 'pylsp', {
      settings: {
        pylsp: {
          plugins: {
            autopep8: {
              enabled: true
            }
          }
        }
      }
    }
    @linter\set 'python', {'pylint'}
