class Fugitive
  apply: (nvim, plugins, maps) =>
    plugins\require 'tpope/vim-fugitive'
    plugins\require 'airblade/vim-gitgutter'

    with maps\add!\space!
      \keys('gs')\cmd('Git')\apply!
      \keys('gc')\cmd('Git commit')\apply!
      \keys('gb')\cmd('Git blame')\apply!
      \keys('gp')\cmd('GitGutterPrevHunk')\apply!
      \keys('gn')\cmd('GitGutterNextHunk')\apply!

Fugitive