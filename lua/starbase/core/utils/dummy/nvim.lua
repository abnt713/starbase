return {
  api = {
    nvim_set_keymap = function() return '' end,
    nvim_get_runtime_file = function() return '' end,
  },
  split = function () return {} end,
  cmd = function() return nil end,
  env = {
    MYVIMRC = '',
  },
  fn = {
    exists = function() return true end,
    getcwd = function() return '' end,
    filereadable = function() return 1 end,
    fnamemodify = function() return '' end,
    readfile = function() return '' end,
    json_decode = function() return {go = {tags = {'foo', 'bar'}}} end,
  },
  o = {
    shortmess = ''
  },
  opt = {},
  wo = {},
  bo = {},
  g = {},
}
