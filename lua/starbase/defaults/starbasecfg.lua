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
