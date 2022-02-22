return {
  api = {
    nvim_set_keymap = function() return '' end,
  },
  cmd = function() return nil end,
  fn = {
    exists = function() return true end,
    getcwd = function() return '' end,
    filereadable = function() return 1 end,
    readfile = function() return '' end,
    decode = function() return {go = {tags = {'foo', 'bar'}}} end,
  },
  o = {
    shortmess = ''
  },
  wo = {},
  bo = {},
  g = {},
}
