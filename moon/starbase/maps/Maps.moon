class Maps
  new: (nvim) =>
    @nvim = nvim

  add: =>
    require('starbase.maps.Map') @nvim

Maps
