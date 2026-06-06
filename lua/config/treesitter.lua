-- ============================================
-- Treesitter 配置
-- ============================================

require'nvim-treesitter.configs'.setup {
  -- 要安装的解析器列表
  ensure_installed = { 
    "c", 
    "cpp", 
    "lua", 
    "vim", 
    "vimdoc", 
    "query", 
    "python", 
    "javascript", 
    "typescript",
    "html", 
    "css", 
    "json", 
    "yaml", 
    "markdown",
    "bash",
    "cmake",
  },
  
  -- 自动安装缺失的解析器
  auto_install = true,
  
  -- 语法高亮
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  
  -- 智能缩进
  indent = {
    enable = true,
  },
  
  -- 增量选择
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      scope_incremental = "<S-CR>",
      node_decremental = "<BS>",
    },
  },
}