
require('plugins')
vim.opt.termguicolors = true
require("bufferline").setup()
vim.cmd[[colorscheme tokyonight-night]]
require('config.lualine')
require('config.alpha')
require("ibl").setup()
require('neo-tree').setup()


-- 加载友好代码片段
require('luasnip.loaders.from_vscode').lazy_load()
local cmp = require'cmp'
local luasnip = require'luasnip'

-- 只在 lspkind 可用时加载
local lspkind_status, lspkind = pcall(require, 'lspkind')
local formatting = {}

if lspkind_status then
  formatting.format = lspkind.cmp_format({
    mode = 'symbol_text',
    maxwidth = 50,
    ellipsis_char = '...',
    before = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
        nvim_lua = '[Lua]',
      })[entry.source.name]
      return vim_item
    end
  })
else
  formatting = {
    fields = {'abbr', 'kind', 'menu'},
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
        nvim_lua = '[Lua]',
      })[entry.source.name]
      return vim_item
    end
  }
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lua' },
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- 回车确认补全
    
    -- 超级Tab功能
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
  formatting = formatting,  -- 使用上面定义的格式化配置
  experimental = {
    ghost_text = true,
  },
})

local lspconfig = require('lspconfig')





require('mason').setup()
require('mason-lspconfig').setup({
  automatic_installation = true,
})

-- 独立配置 LSP（新版不再需要 setup_handlers）

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').clangd.setup({
  cmd = {
    'D:/neovim/custom/clangd/bin/clangd.exe',  -- 替换为你的实际路径
    '--background-index',
    '--clang-tidy',
  },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
local lspconfig = require('lspconfig')
-- 通用配置
local default_setup = function(server)
  lspconfig[server].setup({
    capabilities = capabilities,
  })
end




