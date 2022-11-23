class Cpp
  id: =>
    'cpp'

  new: (lsp) =>
    @lsp = lsp

  apply: () =>
    @lsp\add_server 'ccls', {}
