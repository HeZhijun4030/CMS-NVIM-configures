-- ============================================
-- nvim-cmp 补全配置
-- ============================================

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

-- 加载 VS Code 风格片段
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load({ paths = vim.fn.stdpath('config') .. '/snippets' })

-- 设置 snippet 引擎
luasnip.config.setup({
  history = true,
  updateevents = 'TextChanged,TextChangedI',
})

-- ============================================
-- nvim-cmp 主配置
-- ============================================
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  
  mapping = cmp.mapping.preset.insert({
    -- 滚动文档
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    
    -- 手动触发补全
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    
    -- 取消补全
    ['<C-e>'] = cmp.mapping.abort(),
    
    -- 回车确认补全
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    
    -- 超级 Tab 功能
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif vim.fn.col('.') == 1 and vim.fn.charpos('.')[2] == 0 then
        -- 行首按 Tab 插入真正的 Tab
        fallback()
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
    
    -- 跳转到下一个 placeholder
    ['<C-l>'] = cmp.mapping(function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { 'i', 's' }),
    
    ['<C-h>'] = cmp.mapping(function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { 'i', 's' }),
  }),
  
  -- 补全来源
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 10 },
    { name = 'luasnip', priority = 8 },
    { name = 'buffer', priority = 5, keyword_length = 3 },
    { name = 'path', priority = 3 },
    { name = 'nvim_lua', priority = 7 },
  }, {
    { name = 'calc' },      -- 计算器功能（需要安装 cmp-calc）
  }),
  
  -- 格式化显示
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',      -- 显示符号和文字
      maxwidth = 50,
      ellipsis_char = '...',
      before = function(entry, vim_item)
        -- 添加来源标签
        local sources = {
          nvim_lsp = '[LSP]',
          luasnip = '[Snippet]',
          buffer = '[Buffer]',
          path = '[Path]',
          nvim_lua = '[Lua]',
          calc = '[Calc]',
        }
        vim_item.menu = sources[entry.source.name] or '[Unknown]'
        
        -- 设置高亮组
        if entry.source.name == 'luasnip' then
          vim_item.kind_hl_group = 'CmpItemKindSnippet'
        end
        
        return vim_item
      end
    })
  },
  
  -- 实验性功能
  experimental = {
    ghost_text = true,
    native_menu = false,
  },
  
  -- 窗口样式
  window = {
    completion = {
      border = 'rounded',
      winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
    },
    documentation = {
      border = 'rounded',
      max_width = 80,
      max_height = 20,
    },
  },
  
  -- 排序逻辑
  sorting = {
    priority_weight = 2,
    comparators = {
      require('cmp.config.compare').offset,
      require('cmp.config.compare').exact,
      require('cmp.config.compare').score,
      require('cmp.config.compare').recently_used,
      require('cmp.config.compare').kind,
      require('cmp.config.compare').sort_text,
      require('cmp.config.compare').length,
      require('cmp.config.compare').order,
    },
  },
  
  -- 性能优化
  performance = {
    throttle = 60,
    fetching_timeout = 500,
    max_view_entries = 50,
  },
})

-- ============================================
-- 命令行模式补全
-- ============================================

-- 搜索命令 (/ 或 ?)
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- 命令模式 (:)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- ============================================
-- 自定义高亮组
-- ============================================
vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { link = 'CmpItemKind', default = true })
vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = '#98be65' })

print("Completion configured successfully!")