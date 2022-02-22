local NvimMapper = {}
NvimMapper.__index = NvimMapper

function NvimMapper.new(nvim)
  return setmetatable({
    nvim = nvim,
    descriptions = {},
  }, NvimMapper)
end

function NvimMapper.map(self, keys_combo, cmd, description, mode, opts)
  local mapped_cmd = cmd
  if type(mapped_cmd) == 'table' then
    local fn_name = cmd[1]
    local fn_value = cmd[2]
    finalfrontier[fn_name] = fn_value
    mapped_cmd = '<cmd>lua finalfrontier.' .. fn_name .. '()<CR>'
  end
  local map_mode = mode or 'n'
  local options = {noremap = true}
  if opts then options = self.nvim.tbl_extend('force', options, opts) end
  self.nvim.api.nvim_set_keymap(map_mode, keys_combo, mapped_cmd, options)
  self:add_description(keys_combo, mapped_cmd, description, map_mode)
end

function NvimMapper.spacemap(self, keys_combo, cmd, description, mode, opts)
  return self:map('<space>' .. keys_combo, cmd, description, mode, opts)
end

function NvimMapper.leadermap(self, keys_combo, cmd, description, mode, opts)
  return self:map('<leader>' .. keys_combo, cmd, description, mode, opts)
end

function NvimMapper.describe(self, keys_combo)
  local description = self.descriptions[keys_combo]
  if description == nil then return end

  -- TODO: Abstract the information board.
  print('Describing map "' .. keys_combo .. '": ' .. description.description)
end

function NvimMapper.add_description(self, keys_combo, cmd, description, mode)
  local desc = {}
  desc['description'] = description
  desc[mode] = cmd

  self.descriptions[keys_combo] = desc
end

return NvimMapper
