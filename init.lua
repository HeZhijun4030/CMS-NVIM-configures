require('plugins')
vim.opt.termguicolors = true

require("bufferline").setup()
vim.cmd[[colorscheme tokyonight-night]]
require('config.lualine')
require('config.alpha')
require("ibl").setup()

-- neo-tree 最小配置
require('neo-tree').setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  default_component_configs = {
    indent = {
      with_expanders = true,
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "",
    },
  },
})

-- 加载友好代码片段
require('luasnip.loaders.from_vscode').lazy_load()
local cmp = require('cmp')
local luasnip = require('luasnip')

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
  formatting = formatting,
  experimental = {
    ghost_text = true,
  },
})

-- Mason 配置
require('mason').setup()
require('mason-lspconfig').setup({
  automatic_installation = true,
})

-- LSP 通用能力配置
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- 使用新的 vim.lsp.config API（替代 lspconfig）
-- 配置 clangd
vim.lsp.config.clangd = {
  cmd = { "clangd" },
  root_markers = { '.git', 'compile_commands.json', 'CMakeLists.txt' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  capabilities = capabilities,
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  end,
}

-- 启用 clangd
vim.lsp.enable('clangd')

-- 可选：配置其他 LSP 服务器
-- Python
vim.lsp.config.pylsp = {
  cmd = { 'pylsp' },
  root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
  filetypes = { 'python' },
  capabilities = capabilities,
}
vim.lsp.enable('pylsp')

-- TypeScript/JavaScript
vim.lsp.config.tsserver = {
  cmd = { 'typescript-language-server', '--stdio' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
  capabilities = capabilities,
}
vim.lsp.enable('tsserver')

-- 定义 include 路径查找函数
local function get_cpp_include_paths()
  local include_paths = {}
  
  -- 从编译数据库获取 include 路径
  local compile_commands = vim.fn.findfile('compile_commands.json', vim.fn.getcwd() .. ';')
  if compile_commands ~= '' then
    local success, result = pcall(vim.fn.json_decode, vim.fn.readfile(compile_commands))
    if success and result then
      for _, cmd in ipairs(result) do
        if cmd.arguments then
          for _, arg in ipairs(cmd.arguments) do
            local inc = arg:match('^-I(.+)$')
            if inc then
              table.insert(include_paths, inc)
            end
          end
        end
      end
    end
  end
  
  return include_paths
end

-- 添加项目根目录检测功能
local function find_project_root()
  local markers = { 
    '.git', 'compile_commands.json', 'CMakeLists.txt', 
    'Makefile', 'build.ninja', 'meson.build'
  }
  local root_dir = vim.fn.getcwd()
  for _, marker in ipairs(markers) do
    local found = vim.fn.findfile(marker, root_dir .. ';')
    if found ~= '' then
      return vim.fn.fnamemodify(found, ':p:h')
    end
  end
  return root_dir
end

-- 添加自动命令来更新 include 路径
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  pattern = { "*.cpp", "*.hpp", "*.c", "*.h", "*.cc", "*.cxx" },
  callback = function()
    local root_dir = find_project_root()
    if root_dir ~= vim.fn.getcwd() then
      vim.notify("Project root: " .. root_dir, vim.log.levels.INFO)
    end
  end,
})

-- 添加诊断显示配置
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- 添加 include 辅助函数
vim.api.nvim_create_user_command('CppAddInclude', function(opts)
  local include_path = opts.args
  vim.notify("Added include path: " .. include_path .. " (manual)", vim.log.levels.INFO)
end, {
  nargs = 1,
  desc = 'Add include path (manual)',
  complete = 'file'
})

print("Neovim config loaded successfully!")
