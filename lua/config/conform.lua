-- ============================================
-- conform.nvim 格式化配置
-- ============================================

require('conform').setup({
  -- 按文件类型配置格式化工具
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    json = { 'prettierd', 'prettier' },
    jsonc = { 'prettierd', 'prettier' },
    yaml = { 'prettierd', 'prettier' },
    markdown = { 'prettierd', 'prettier' },
    html = { 'prettierd', 'prettier' },
    css = { 'prettierd', 'prettier' },
    scss = { 'prettierd', 'prettier' },
    c = { 'clang-format' },
    cpp = { 'clang-format' },
    proto = { 'clang-format' },
    rust = { 'rustfmt' },
    go = { 'gofmt', 'goimports' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
  },
  
  -- 保存时自动格式化
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,  -- 如果没有配置格式化工具，回退到 LSP 格式化
  },
  
  -- 通知设置
  notify_on_error = true,
  
  -- 日志级别
  log_level = vim.log.levels.WARN,
  
  -- 自定义格式化选项
  formatters = {
    black = {
      prepend_args = { '--quiet' },
    },
    prettier = {
      condition = function(ctx)
        -- 只在有配置文件时才运行 prettier
        local config_files = {
          '.prettierrc',
          '.prettierrc.json',
          '.prettierrc.yaml',
          '.prettierrc.yml',
          '.prettierrc.js',
          '.prettierrc.cjs',
          '.prettierrc.toml',
          'prettier.config.js',
          'prettier.config.cjs',
        }
        for _, file in ipairs(config_files) do
          if vim.fn.filereadable(vim.fn.getcwd() .. '/' .. file) == 1 then
            return true
          end
        end
        return false
      end,
    },
    stylua = {
      prepend_args = { '--indent-type', 'Spaces', '--indent-width', '2' },
    },
  },
})

-- ============================================
-- nvim-lint 异步代码检查配置
-- ============================================
local lint = require('lint')

lint.linters_by_ft = {
  python = { 'pylint' },
  javascript = { 'eslint' },
  typescript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescriptreact = { 'eslint' },
  lua = { 'selene' },
  markdown = { 'vale' },
}

-- 保存时自动 lint
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    lint.try_lint()
  end,
})

-- ============================================
-- 手动格式化快捷键
-- ============================================
vim.keymap.set('n', '<leader>lf', function()
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format current buffer' })

vim.keymap.set('v', '<leader>lf', function()
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format selected range' })

print("Formatter and linter configured successfully!")