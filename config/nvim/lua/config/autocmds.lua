-- ============================================================================
--  自动命令
-- ============================================================================

local group  = vim.api.nvim_create_augroup
local create = vim.api.nvim_create_autocmd

-- ---------- yank 高亮 ----------
group('YankHighlight', { clear = true })
create('TextYankPost', {
    group    = 'YankHighlight',
    callback = function()
        vim.hl.on_yank({ higroup = 'IncSearch', timeout = 200 })
    end,
})

-- ---------- 按文件类型微调 ----------
group('FiletypeSettings', { clear = true })

create('FileType', {
    group   = 'FiletypeSettings',
    pattern = { 'markdown', 'json', 'jsonc', 'yaml', 'toml', 'text' },
    callback = function() vim.opt_local.wrap = true end,
})

