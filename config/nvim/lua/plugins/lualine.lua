-- ============================================================================
--  lualine.nvim — 状态栏
-- ============================================================================
--  配色：自动跟 catppuccin
-- ============================================================================

require('lualine').setup({
    options = {
        theme                = 'auto',   -- 自动适配当前 colorscheme（catppuccin 友好）
        component_separators = '│',
        section_separators   = '│',
    },
    sections = {
        lualine_a = { 'mode' },                  -- 模式
        lualine_b = { 'branch', 'diff', 'diagnostics' },  -- git / 改动 / 错误数
        lualine_c = { 'filename' },              -- 文件名
        lualine_x = { 'filetype', 'progress', 'location' },  -- 文件类型 / 进度 % / 行:列
        lualine_y = { 'encoding', 'fileformat', 'filemode' }, -- 编码 / 行尾 / +- 改动
        lualine_z = { 'time' },                  -- 时间
    },
    -- 不填 extensions：bufferline 顶部已自己渲染标签，gitsigns 有自己的 gutter
    -- extensions = { 'fugitive', 'nvim-tree' },  -- 如果你装了其他插件可加这里
})