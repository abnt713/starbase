class Debug
  apply: (nvim, plugins, maps) =>
    plugins\require 'mfussenegger/nvim-dap'

    with maps\add!\leader!
      \keys('b')\lua([[require('dap').toggle_breakpoint()]])\apply!
      \keys('<s-b>')\lua([[require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))]])\apply!
      \keys('v')\lua([[require('dap').list_breakpoints(true)]])\apply!
      \keys('d')\lua([[require('dap').repl.toggle()]])\apply!
      \keys('c')\lua([[require('dap').continue()]])\apply!

Debug
