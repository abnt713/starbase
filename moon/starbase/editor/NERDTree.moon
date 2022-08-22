class NERDTree
  id: =>
    'nerdtree'

  apply: (nvim, plugins, maps) =>
    with plugins\require 'preservim/nerdtree'
      \require 'ryanoasis/vim-devicons'

    nvim.cmd 'let NERDTreeShowLineNumbers = 1'
    maps\add!\space!\keys('ft')\cmd('NERDTreeToggle')\apply!

NERDTree
