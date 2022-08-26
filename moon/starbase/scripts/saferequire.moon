(cfgmodule, fallback) ->
  loader = () -> require cfgmodule
  if pcall(loader) 
    return require cfgmodule 
  else 
    return fallback
