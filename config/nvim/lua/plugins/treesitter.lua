-- ============================================================================
--  nvim-treesitter (2026 main 分支)
-- ============================================================================
--  先决条件（不在本配置里）：
--    系统装 tree-sitter CLI >= 0.26.1
--      NixOS:  nix-env -iA nixpkgs.tree-sitter
--      其他:   cargo install tree-sitter-cli --locked
--    验证:    :!tree-sitter --version
--
--  新 API 注意事项（对比老 master 分支）：
--    - :TSInstall 命令还在（可装 tier 名：stable / unstable / all）
--    - 也可用 Lua API: require'nvim-treesitter'.install({...} | 'stable')
--    - features 不再默认开启，要手动开高亮/缩进/折叠
--    - 必须装到 install_dir；setup() 可省略（默认 = stdpath('data')..'/site'）
--    - 升级插件后必须 :TSUpdate 重新编译所有 parser
-- ============================================================================

require('nvim-treesitter').setup({
    -- parser / query 装到这里
    -- 装在 ~/.config/nvim/treesitter/ 下，配置集中管理
    -- 注意：这会是 .gitignore 的候选（编译产物 + 几百 MB）
    install_dir = vim.fn.stdpath('config') .. '/treesitter',
    -- 新版 setup() 会自动把 install_dir prepend 到 runtimepath，无需手动加
})

-- ---------- 要装的 parser ----------
--  2026 main 分支 tier 现状（反直觉但准确）：
--    tier 1 stable     = 只有 9 个（都是 niche 语言，主流如 lua/rust/nix 都是 tier 2）
--    tier 2 unstable   = 306 个（这里是几乎所有主流语言）
--    tier 3 unmaintained = 8 个
--
--  tier 名可传:
--    'stable'   只装 tier 1（不要用，只有 9 个！）
--    'unstable' 只装 tier 2
--    'all'      tier 1+2+3（323 个，推荐）
--
--  首次会比较慢（300+ parser 编译 10-20 分钟），后台异步不阻塞启动
--  已装的会跳过
require('nvim-treesitter').install('all')

-- ---------- 启用 features ----------
-- 高亮/缩进/折叠在新版都是手动的（不是全局开关）
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('TreesitterFeatures', { clear = true }),
    callback = function()
        -- 高亮：无 parser 时 pcall 静默失败
        pcall(vim.treesitter.start)

        -- 缩进：插件自带的 indentexpr（标记 experimental，但很稳）
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        -- 折叠：用 Neovim 内置 treesitter foldexpr
        -- foldenable = false → 默认不折叠，za 手动展开
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldenable = false
    end,
})

-- ============================================================================
--  可选快捷键（折叠操作）
-- ============================================================================
--  这些键和现有 gitsigns / LSP 都不冲突，可按需启用
--
-- map('n', 'zR', vim.cmd.diffupdate,    { desc = 'treesitter: 全展开'  }) -- zR 已存在
-- map('n', 'za', '<cmd>normal! za<cr>', { desc = 'treesitter: 切换折叠' }) -- za 已存在
-- zR / za 是 nvim 内置 fold 命令，不用重新绑定

-- ============================================================================
--  常用维护命令
-- ============================================================================
--  :TSInstall {lang}         安装 parser 或 tier（stable/unstable/all）
--  :TSInstall all             安装所有（tier 1+2+3，约 323 个）
--  :TSInstall unstable        只装 tier 2（约 306 个）
--  :TSUpdate [{lang}]         更新已装的 parser
--  :TSUninstall {lang|all}    卸载
--  :TSReinstall              清空 + 重装 all（自定义）
--  :TSLog                     查看安装/更新的日志输出
--  :checkhealth nvim-treesitter  健康检查（看已装/可装状态）
--
--  查看已装哪些：
--    :lua require'nvim-treesitter'.get_installed()
--  查看可装哪些：
--    :lua require'nvim-treesitter'.get_available()
-- ============================================================================

-- ============================================================================
--  一键重装命令 :TSReinstall
-- ============================================================================
--  清空 install_dir/parser 后重新装 stable tier
--  用于：插件大版本升级后 query 不兼容 / parser 损坏 / 想重置
--  query/indents 文件保留不动（这些是纯文本、跟插件版本走）
vim.api.nvim_create_user_command('TSReinstall', function()
    -- setup() 会把 install_dir 放到 rtp 最前面，取它就是
    local install_dir = vim.split(vim.o.rtp, ',')[1]
    local parser_dir  = install_dir .. '/parser'

    if vim.fn.isdirectory(parser_dir) == 0 then
        vim.notify('parser 目录不存在，无需重装: ' .. parser_dir, vim.log.levels.WARN)
        return
    end

    -- 二次确认（误删无价）
    local choice = vim.fn.confirm(
        string.format('将删除 %s\n并重新编译所有 parser（10-20 分钟），确认？', parser_dir),
        '&Yes\n&No',
        2  -- 默认选 No（取消）
    )
    if choice ~= 1 then
        vim.notify('已取消', vim.log.levels.INFO)
        return
    end

    -- 清空 parser 目录
    vim.fn.delete(parser_dir, 'rf')
    vim.notify('已清空 ' .. parser_dir .. '，重新安装 stable tier...', vim.log.levels.INFO)

    -- 异步重装
    require('nvim-treesitter').install('all')
end, { desc = 'treesitter: 清空 parser 并重装 all tier' })