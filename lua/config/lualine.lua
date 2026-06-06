-- ============================================
-- Lualine 状态栏配置
-- ============================================

require('lualine').setup({
  options = {
    theme = 'tokyonight',
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = { 'NvimTree', 'neo-tree' },
    always_divide_middle = true,
    globalstatus = true,
  },
  
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1,  -- 0: 只显示文件名, 1: 相对路径, 2: 绝对路径
      },
      'navic',  -- 代码导航 (需要 nvim-navic)
    },
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype',
      'progress',
    },
    lualine_y = { 'location' },
    lualine_z = {
      function()
        return os.date('%H:%M')
      end,
    }
  },
  
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  
  tabline = {},
  extensions = { 'neo-tree', 'fugitive', 'nvim-tree' },
})