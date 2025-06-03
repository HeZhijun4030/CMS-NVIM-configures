
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end


return require('packer').startup(function(use)
-- basic
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'  
  use 'nvim-telescope/telescope.nvim'  

  use 'folke/tokyonight.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use 'akinsho/bufferline.nvim'
  use {
    'goolord/alpha-nvim',
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  } 
  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  })

  use 'nvim-treesitter/nvim-treesitter'
  use 'lukas-reineke/indent-blankline.nvim'
--more
  -- 语法高亮
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }


  -- 代码片段
 


  -- 格式化
  use 'jose-elias-alvarez/null-ls.nvim'

  -- 注释
  use 'numToStr/Comment.nvim'

  -- 自动配对
  use 'windwp/nvim-autopairs'

  -- 缩进线
  use 'lukas-reineke/indent-blankline.nvim'
  




  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'
  -- 代码片段支持
  use 'L3MON4D3/LuaSnip'         -- 代码片段引擎
  use 'onsails/lspkind.nvim'
  use 'rafamadriz/friendly-snippets' -- 预设片段集合

end)