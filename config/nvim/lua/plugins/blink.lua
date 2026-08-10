-- ============================================================================
--  blink.cmp v2 — 最简化补全
-- ============================================================================
--  v2 默认 sources = {'lsp'}，下面显式写出来便于日后扩展
--  触发：InsertEnter 自动按 LSP capability 启用，无需 on_attach
--
--  当前键位（preset = 'enter'）：
--    <CR>         确认选中项（没选中时 = 普通回车）← 关键改动
--    <Tab>/<S-Tab> 选中项时切换；未选中 = 原行为
--    <C-n>/<C-p>  备选项上下移动
--    <C-e>        取消（隐藏菜单）
--    <C-Space>    手动触发补全
--    <C-k>        签名帮助（函数参数提示）
--
--  其他 preset 选项：
--    'default'   <C-y> 确认（要按 <C-y> 才确认，适合不愿让 <CR> 误触发的）
--    'super-tab' Tab = 接受；不选 <CR> 确认
--    'enter'     <CR> 确认（当前选项）
--    'cmdline'   在 : 命令行模式下使用
--    'none'      禁用所有键位
--
--  想加 snippet 展开：装 LuaSnip 后改 snippets.preset = 'luasnip'
--  想加路径/buffer 补全：在 sources.default + sources.providers 里加 'path' / 'buffer'
-- ============================================================================

require('blink.cmp').setup({
    -- 只用 LSP source；path/buffer/snippet 暂不启用
    sources = {
        default = { 'lsp' },
        providers = {
            lsp = {
                name   = 'LSP',
                module = 'blink.cmp.sources.lsp',
            },
        },
    },

    -- 用 'enter' preset：<CR> 确认选中项（fallback 保证没选中时还是换行）
    -- 其他键位（<C-n>/<C-p>、<Tab>/<S-Tab>、<C-e> 取消、<C-space> 触发）保持
    keymap = { preset = 'enter' },

    -- 文档悬浮：悬停选中项时自动显示（默认 true，可关）
    completion = {
        documentation = { auto_show = true },
    },

    -- 模糊匹配：强制走 Lua（跳过 Rust prebuilt binary 下载）
    -- 可选值: 'prefer_rust_with_warning' / 'prefer_rust' / 'rust' / 'lua'
    -- 取 'lua' 后 Rust 完全不参与，启动无 warning、无网络下载
    -- 性能略低于 Rust（frizbee）但 5k 项以内无感
    fuzzy = {
        implementation = 'lua',
    },
})
