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
  stages = {
    go = {
      enabled = false,
      linters = {'revive'},
    },
    lua = {
      enabled = false,
      linters = {'luacheck'}
    },
    python = {
      enabled = false,
      linters = {'flake8'}
    }
  },
  project = {
    file = 'starbase.json'
  },
}
