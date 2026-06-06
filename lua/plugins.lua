-- ============================================
-- Packer 插件管理器配置 (Windows 版)
-- ============================================

local fn = vim.fn
local data_path = fn.stdpath('data')
local install_path = data_path .. '/site/pack/packer/start/packer.nvim'

-- 自动安装 Packer
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
    -- 包管理器本身
    use 'wbthomason/packer.nvim'

    -- 基础依赖
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    -- 主题和 UI
    use 'folke/tokyonight.nvim'
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use 'akinsho/bufferline.nvim'
    use 'goolord/alpha-nvim'
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    }
    use 'lukas-reineke/indent-blankline.nvim'

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }

    -- LSP 相关
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'

    -- 补全系统
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'saadparwaiz1/cmp_luasnip'

    -- 代码片段
    use 'L3MON4D3/LuaSnip'
    use 'onsails/lspkind.nvim'
    use 'rafamadriz/friendly-snippets'

    -- 其他工具
    use 'numToStr/Comment.nvim'
    use 'windwp/nvim-autopairs'

    -- 格式化工具
    use 'stevearc/conform.nvim'
    use 'mfussenegger/nvim-lint'
end)