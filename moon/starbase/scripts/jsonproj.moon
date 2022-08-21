(proj_file, nvim) ->
  fullproj_file = nvim.fn.getcwd! .. '/' .. proj_file
  exists = (nvim.fn.filereadable fullproj_file) == 1
  if not exists
    return {}
  raw = nvim.fn.readfile fullproj_file
  result = nvim.fn.json_decode(raw)
  if not result
    return {}
  result
