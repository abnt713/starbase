local Go = {}
Go.__index = Go

function Go.new(self, nvim)
  local subtests_query = [[
  (call_expression
  function: (selector_expression
    operand: (identifier)
    field: (field_identifier) @run)
    arguments: (argument_list
    (interpreted_string_literal) @testname
    (func_literal))
    (#eq? @run "Run")) @root
    ]]

  return setmetatable({
    nvim = nvim,
    subtests_query = subtests_query,
  }, self)
end

function Go.run_for_ft(self, ft)
  local query = require('vim.treesitter.query')
  local stop_row = self.nvim.api.nvim_win_get_cursor(0)[1]
  local parser = self.nvim.treesitter.get_parser(0)
  local root = (parser:parse()[1]):root()

  local subtest_query = self.nvim.treesitter.parse_query(ft, self.subtests_query)
  for _, match, _ in subtest_query:iter_matches(root, 0, 0, stop_row) do
    print(self.nvim.inspect(match))
    local test_match = {}
    for id, node in pairs(match) do
      local capture = subtest_query.captures[id]
      if capture == "testname" then
        local name = query.get_node_text(node, 0)
        test_match.name = string.gsub(string.gsub(name, ' ', '_'), '"', '')
      end
      if capture == "root" then
        test_match.node = node
      end
    end
    print(self.nvim.inspect(test_match))
  end
end

return Go

