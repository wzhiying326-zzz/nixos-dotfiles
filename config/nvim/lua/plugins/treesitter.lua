-- ============================================================================
--  nvim-treesitter (2026 main 分支)
-- ============================================================================
--
--  先决条件：
--    装 tree-sitter CLI >= 0.26.1
--      NixOS: nix-env -iA nixpkgs.tree-sitter
--      其他:  cargo install tree-sitter-cli --locked
--    验证:  :!tree-sitter --version
--
--  维护命令：
--    :TSInstall {lang|tier}    安装 parser 或 tier（stable/unstable/all）
--    :TSUpdate [{lang}]        更新已装 parser
--    :TSUninstall {lang|all}   卸载
--    :TSLog                    查看安装/更新日志
--    :checkhealth nvim-treesitter
--    已装列表: :lua require'nvim-treesitter'.get_installed()
--    可装列表: :lua require'nvim-treesitter'.get_available()
--
--  关键差异（对比老 master 分支）：
--    - :TSInstall 接受 tier 名（stable / unstable / all）
--    - 也可用 Lua API: require'nvim-treesitter'.install({...} | 'all')
--    - features 不再默认开启（高亮/缩进/折叠见下方 FileType autocmd）
--    - 升级插件后必须 :TSUpdate 重新编译所有 parser
--
--  tier 现状（反直觉）：
--    tier 1 stable       = 9 个（niche 语言）
--    tier 2 unstable     = 306 个（几乎所有主流语言，含 lua/rust/nix）
--    tier 3 unmaintained = 8 个
--    → 'stable' 只装 9 个，要"几乎所有"必须用 'all'
-- ============================================================================

require('nvim-treesitter').setup({
    install_dir = vim.fn.stdpath('data') .. '/treesitter',
    -- setup() 自动 prepend 到 runtimepath
})

require('nvim-treesitter').install('all') -- 首次编译 10-20 分钟，后台异步；已装会跳过

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('TreesitterFeatures', { clear = true }),
    callback = function()
        pcall(vim.treesitter.start)                                       -- 高亮（无 parser 时静默失败）

        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- 缩进

        vim.wo.foldmethod = 'expr'                                        -- 折叠
        vim.wo.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldenable = false                                         -- 默认折叠
    end,
})

