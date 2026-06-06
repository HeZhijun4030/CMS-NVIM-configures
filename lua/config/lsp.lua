-- ============================================
-- LSP 配置
-- ============================================

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- ============================================
-- 通用 on_attach 函数
-- ============================================
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>f', function() 
    vim.lsp.buf.format { async = true } 
  end, bufopts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
end

-- ============================================
-- C/C++ (clangd)
-- ============================================
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
    fallbackFlags = { "-std=c++17" },
  },
}

-- ============================================
-- Python (pylsp)
-- ============================================
lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = true },
        pycodestyle = { enabled = true, maxLineLength = 88 },
        rope_completion = { enabled = true },
        jedi_completion = { enabled = true },
        jedi_definition = { enabled = true },
        autopep8 = { enabled = true },
      }
    }
  }
}

-- ============================================
-- TypeScript/JavaScript (ts_ls - 替代已弃用的 tsserver)
-- ============================================
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 
    "typescript", 
    "javascript", 
    "typescriptreact", 
    "javascriptreact",
    "vue",
  },
}

-- ============================================
-- Lua (lua_ls)
-- ============================================
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { 
        version = 'LuaJIT',
        path = vim.split(package.path, ';')
      },
      diagnostics = { 
        globals = { 'vim' },
        disable = { 'missing-fields' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    }
  }
}

-- ============================================
-- JSON (jsonls) - 简化版，不使用 schemastore
-- ============================================
lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- ============================================
-- YAML (yamlls) - 简化版
-- ============================================
lspconfig.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- ============================================
-- 诊断配置
-- ============================================
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = true,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
})

print("LSP configured successfully!")