-- ============================================
-- Alpha (Dashboard) 启动页配置
-- ============================================

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

-- 自定义 header
dashboard.section.header.val = [[
 ██████╗ ██████╗ ██████╗ ███████╗ ███╗   ███╗ █████╗ ███╗   ██╗███████╗ ████████╗██╗   ██╗██████╗ ██╗ ██████╗ 
██╔════╝██╔═══██╗██╔══██╗██╔════╝ ████╗ ████║██╔══██╗████╗  ██║██╔════╝ ╚══██╔══╝██║   ██║██╔══██╗██║██╔═══██╗
██║     ██║   ██║██║  ██║█████╗   ██╔████╔██║███████║██╔██╗ ██║███████╗    ██║   ██║   ██║██║  ██║██║██║   ██║
██║     ██║   ██║██║  ██║██╔══╝   ██║╚██╔╝██║██╔══██║██║╚██╗██║╚════██║    ██║   ██║   ██║██║  ██║██║██║   ██║
╚██████╗╚██████╔╝██████╔╝███████╗ ██║ ╚═╝ ██║██║  ██║██║ ╚████║███████║    ██║   ╚██████╔╝██████╔╝██║╚██████╔╝
 ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝    ╚═╝    ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ 
                                                                                                            
]]

-- Header 样式
dashboard.section.header.opts = {
  position = "center",
  hl = "AlphaHeader",
}

-- 按钮配置
dashboard.section.buttons.val = {
  dashboard.button("e", "   New File", ":ene <BAR> startinsert <CR>"),
  dashboard.button("r", "   Recent Files", ":Telescope oldfiles<CR>"),
  dashboard.button("f", "󰈞   Find File", ":Telescope find_files<CR>"),
  dashboard.button("g", "󰊄   Live Grep", ":Telescope live_grep<CR>"),
  dashboard.button("p", "󰏗   Packer Sync", ":PackerSync<CR>"),
  dashboard.button("q", "   Quit", ":qa<CR>"),
}

-- 底部信息
dashboard.section.footer.val = {
  " ",
  "🧐",
  "Hey HeZhijun, welcome back!",
  "Have a good day!",
  " ",
  "📅  " .. os.date("%Y-%m-%d"),
  "⏰  " .. os.date("%H:%M"),
  " ",
  "⚡ Neovim " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
}

-- Footer 样式
dashboard.section.footer.opts = {
  position = "center",
  hl = "AlphaFooter",
}

-- 设置 alpha
alpha.setup(dashboard.opts)

-- 自定义高亮
vim.cmd([[
  hi AlphaHeader guifg=#98be65 gui=bold
  hi AlphaFooter guifg=#51afef
  hi AlphaButtons guifg=#c678dd
]])