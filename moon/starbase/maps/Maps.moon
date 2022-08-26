export _mapped_functions = {}

class Maps
  new: (nvim) =>
    @nvim = nvim

  add: =>
    export _mapped_functions
    require('starbase.maps.Map') @nvim, _mapped_functions

Maps
