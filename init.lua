require('plugins')

vim.opt.termguicolors = true

-- UI 配置
require("bufferline").setup()
vim.cmd[[colorscheme tokyonight-night]]
require('config.lualine')
require('config.alpha')
require("ibl").setup()
require('neo-tree').setup()

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
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

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
local lspconfig = require('lspconfig')

-- 通用配置函数
local function setup_lsp(server, custom_opts)
  local opts = vim.tbl_deep_extend("force", {
    capabilities = capabilities,
  }, custom_opts or {})
  lspconfig[server].setup(opts)
end

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
  
  -- 添加常见的系统 include 路径
  local common_paths = {
    '/usr/include',
    '/usr/local/include',
    '/usr/include/c++/*',
    '/usr/include/x86_64-linux-gnu',
    '/usr/include/x86_64-linux-gnu/c++/*',
  }
  
  for _, path in ipairs(common_paths) do
    if path:find('%*') then
      -- 处理通配符路径
      local expanded = vim.fn.glob(path, false, true)
      for _, exp in ipairs(expanded) do
        if vim.fn.isdirectory(exp) == 1 then
          table.insert(include_paths, exp)
        end
      end
    else
      if vim.fn.isdirectory(path) == 1 then
        table.insert(include_paths, path)
      end
    end
  end
  
  return include_paths
end

-- clangd 配置（修复重复定义问题）
setup_lsp('clangd', {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=Google",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- 设置快捷键
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    
    -- 添加 C++ 特定的 include 路径
    local include_paths = get_cpp_include_paths()
    if #include_paths > 0 then
      -- 通知 clangd 添加 include 路径
      client.notify('workspace/didChangeConfiguration', {
        settings = {
          clangd = {
            arguments = { '-I' .. table.concat(include_paths, ' -I') }
          }
        }
      })
    end
  end,
  settings = {
    clangd = {
      -- 添加 include 路径
      arguments = vim.tbl_flatten({
        "-I.",
        vim.tbl_map(function(path) return "-I" .. path end, get_cpp_include_paths())
      }),
    }
  }
})

-- 其他 LSP 服务器配置（如果需要）
local servers = {
  'pyright',      -- Python
  'tsserver',     -- TypeScript/JavaScript
  'rust_analyzer', -- Rust
  'gopls',        -- Go
  'cmake',        -- CMake
}

for _, server in ipairs(servers) do
  setup_lsp(server)
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
      -- 重新启动 clangd 来更新 include 路径
      vim.cmd('LspRestart clangd')
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
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr, name = 'clangd' })
  if #clients > 0 then
    clients[1].notify('workspace/didChangeConfiguration', {
      settings = {
        clangd = {
          arguments = { '-I' .. include_path }
        }
      }
    })
    vim.notify("Added include path: " .. include_path, vim.log.levels.INFO)
  end
end, {
  nargs = 1,
  desc = 'Add include path to clangd',
  complete = 'file'
})
