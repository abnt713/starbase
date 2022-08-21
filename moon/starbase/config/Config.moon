class Config
  new: (values) =>
    if values == nil then values = {}
    @values = values

  get: (key, fallback) =>
    if @values[key] != nil then return @values[key]
    result = @values
    for kp in string.gmatch key, '[^%.]+'
      if type(result) != 'table' then return fallback
      result = result[kp]

    result

  value: (key) =>
    @values[key]

Config
