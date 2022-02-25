local Cmp = {}
Cmp.__index = Cmp

function Cmp.new(nvim, plugin_manager)
  return setmetatable({
    nvim = nvim,
    plugin_manager = plugin_manager,
  }, Cmp)
end

function Cmp.configure(self)
  self.nvim.o.completeopt = 'menu,menuone,noselect'

  self.plugin_manager:add_dependency('hrsh7th/cmp-nvim-lsp')
  self.plugin_manager:add_dependency('hrsh7th/cmp-buffer')
  self.plugin_manager:add_dependency('hrsh7th/cmp-path')

  self.plugin_manager:add_dependency('L3MON4D3/LuaSnip')
  self.plugin_manager:add_dependency('saadparwaiz1/cmp_luasnip')

  self.plugin_manager:add_dependency('hrsh7th/nvim-cmp', self:setup_cmp())
end

function Cmp.setup_cmp(self)
  return function()
    local cmp = self.plugin_manager:require('cmp')
    if not cmp then return end

    local luasnip = self.plugin_manager:require('luasnip')
    if not luasnip then return end

    local has_words_before = function()
      local line, col = unpack(self.nvim.api.nvim_win_get_cursor(0))
      return col ~= 0 and self.nvim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup {
      snippet = {
        expand = function(args)
          local dep = self.plugin_manager:require('luasnip')
          if not dep then return end
          dep.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            return
          end
          fallback()
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
            return
          end
          fallback()
        end, { "i", "s" }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
      })
    }
  end
end

function Cmp.retrieve_capabilities(self)
  local dep = self.plugin_manager:require('cmp_nvim_lsp')
  if not dep then return end
  return dep.update_capabilities(self.nvim.lsp.protocol.make_client_capabilities())
end

return Cmp
