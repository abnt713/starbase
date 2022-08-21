class Config
  new: (values) =>
    if values == nil then values = {}
    @values = values

  get: (key, fallback) =>
    if @values[key] != nil then return @values[key]

  value: (key) =>
    @values[key]

Config
