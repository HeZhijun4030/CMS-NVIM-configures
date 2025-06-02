
require('plugins')
vim.opt.termguicolors = true
require("bufferline").setup()
vim.cmd[[colorscheme tokyonight-night]]
require('config.lualine')
require('config.alpha')
require("ibl").setup()
require('neo-tree').setup()

local cmp = require('cmp')
local luasnip = require('luasnip')

-- 加载友好代码片段
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- 使用 LuaSnip 展开片段
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- 向上滚动文档
    ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- 向下滚动文档
    ['<C-Space>'] = cmp.mapping.complete(),  -- 触发补全
    ['<C-e>'] = cmp.mapping.abort(),        -- 关闭补全窗口
    ['<CR>'] = cmp.mapping.confirm({       -- 确认选择
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    -- Tab 键导航
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },   -- LSP 补全
    { name = 'luasnip' },    -- 代码片段补全
    { name = 'buffer' },     -- 缓冲区文本补全
    { name = 'path' },       -- 文件路径补全
  }),
  -- 可选：添加补全项图标
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
    })
  }
})

-- `/` 搜索时的补全
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })
  
  -- `:` 命令时的补全
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })