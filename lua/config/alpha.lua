
local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = [[
 ██████╗ ██████╗ ██████╗ ███████╗ ███╗   ███╗ █████╗ ███╗   ██╗███████╗ ████████╗██╗   ██╗██████╗ ██╗ ██████╗ 
██╔════╝██╔═══██╗██╔══██╗██╔════╝ ████╗ ████║██╔══██╗████╗  ██║██╔════╝ ╚══██╔══╝██║   ██║██╔══██╗██║██╔═══██╗
██║     ██║   ██║██║  ██║█████╗   ██╔████╔██║███████║██╔██╗ ██║███████╗    ██║   ██║   ██║██║  ██║██║██║   ██║
██║     ██║   ██║██║  ██║██╔══╝   ██║╚██╔╝██║██╔══██║██║╚██╗██║╚════██║    ██║   ██║   ██║██║  ██║██║██║   ██║
╚██████╗╚██████╔╝██████╔╝███████╗ ██║ ╚═╝ ██║██║  ██║██║ ╚████║███████║    ██║   ╚██████╔╝██████╔╝██║╚██████╔╝
 ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝    ╚═╝    ╚═════╝ ╚═════╝ ╚═╝ ╚═════╝ 
                                                                                                            
]]

dashboard.section.header.opts = {
    position = "center",
    hl = "AlphaHeader",  
  }
  
dashboard.section.buttons.val = {

    dashboard.button("e", "   New File", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", "   Recent", ":Telescope oldfiles<CR>"),
    dashboard.button("b", "󰏗   PackerSync", ":PackerSync<CR>"),
    dashboard.button("q", "   Quit", ":qa<CR>"),
}

  
dashboard.section.footer.val = {
    " ",  
    "🧐",
    "Hey HeZhijun welcome back",  
    "Have a good day!",
    "",
    "📅  " .. os.date("%Y-%m-%d"), 
    "⏰  " .. os.date("%H:%M"),
  }



alpha.setup(dashboard.opts)
vim.cmd[[
  hi AlphaHeader guifg=#98be65 gui=bold
]]