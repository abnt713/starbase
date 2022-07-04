return {
  diagnostics = {
    show_on_hover = false,
    virtual_text = true,
  },
  editor = {
    cursorline = {
      enabled = true,
    },
    startup = {
      enabled = false,
      theme = 'dashboard',
    },
    italics = {
      enabled = true,
    },
    gitgutter = {
      enabled = true,
    }
  },
  lsp = {
    autoinstall = true,
  },
  stages = {
    cpp = {
      enabled = false,
    },
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
    },
    rust = {
      enabled = false,
    }
  },
  project = {
    file = 'starbase.json'
  },
}