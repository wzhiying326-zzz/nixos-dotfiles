-- ============================================================================
--  插件清单 & 配置入口
-- ============================================================================
--  装新插件：vim.pack.add({...}) 加一项 → :restart
--  删插件：vim.pack.del({...}) + 从本文件移除 → :restart
--  更新所有插件：vim.pack.update()（确认 buffer 里 :write 生效，:quit 撤销）
-- ============================================================================

local gh = function(repo) return 'https://github.com/' .. repo end

vim.pack.add({
    -- ---------- 主题 ----------
    { src = gh('catppuccin/nvim'),           name = 'catppuccin' },

    -- ---------- LSP（使用系统的语言服务器，不装 mason）----------
    { src = gh('neovim/nvim-lspconfig'),     name = 'nvim-lspconfig' },

    -- ---------- UI ----------
    { src = gh('nvim-lualine/lualine.nvim'),               name = 'lualine.nvim' },

    -- ---------- Git ----------
    { src = gh('lewis6991/gitsigns.nvim'),                 name = 'gitsigns.nvim' },
})

-- 配置（顺序：依赖/主题在前；lualine 必须晚于 bufferline/gitsigns）
require('plugins.catppuccin')
require('plugins.lsp')
require('plugins.gitsigns')
require('plugins.lualine')
