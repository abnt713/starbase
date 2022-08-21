require('starbase.main')(
  require('starbase.scripts.settings')('custom.cfg'),
  require('starbase.scripts.jsonproj')('starbase.json', vim)
)
