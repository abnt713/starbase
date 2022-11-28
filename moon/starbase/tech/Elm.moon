class Elm
  new: (lsp) =>
    @lsp = lsp

  id: =>
    'elm'

  apply: =>
    @lsp\add_server 'elmls', {}
