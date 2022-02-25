return {
  editor = {
    cursorline = {
      enabled = true
    },
    startup = {
      enabled = true,
      theme = 'dashboard',
    },
    italics = {
      enabled = true,
    },
    gitgutter = {
      enabled = true,
    }
  },
  diagnostics = {
    show_on_hover = false,
  },
  layers = {
    go = {
      enabled = false,
      linters = {'revive'},
    },
    lua = {
      enabled = false,
      linters = {'luacheck'}
    }
  },
  project = {
    file = 'starbase.json'
  },
}
