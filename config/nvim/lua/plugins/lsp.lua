-- ============================================================================
--  LSP — 使用系统已装的语言服务器（不装 mason）
-- ============================================================================
--  启用新 server：
--    1) 系统装好可执行文件，如：
--         npm i -g typescript-language-server
--         pip install pyright
--         rustup component add rust-analyzer
--    2) 把名字加进下面 vim.lsp.enable({...})
--    3) 如需自定义 settings，用 vim.lsp.config(name, {...})
--
--  当前默认启用：lua_ls（系统需要 lua-language-server）
-- ============================================================================

-- ---------- 启用 server ----------
vim.lsp.enable({
  'lua_ls',
  -- 取消注释即可启用（前提是系统已装）:
  -- 'ts_ls',         -- typescript-language-server
  -- 'vtsls',         -- vtsls
  -- 'pyright',       -- pyright-langserver
  'rust_analyzer',   -- rust-analyzer
  'nixd',            -- Nix 语言服务器（推荐，2026 趋势，比 nil 更快）
                       -- 想用 nil 换成 'nil_ls'，并取消下面的 nixd config
  -- 'gopls',         -- gopls
  -- 'clangd',        -- clangd
  -- 'html',          -- vscode-html-language-server
  -- 'cssls',         -- vscode-css-language-server
  -- 'jsonls',        -- vscode-json-language-server
  -- 'bashls',        -- bash-language-server
})

-- ---------- lua_ls 专用配置 ----------
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
        disable = { 'missing-fields' },
      },
      workspace = {
        library         = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- ---------- nixd 专用配置 ----------
--  用 nixfmt-rfc-style 格式化（不要用 nixpkgs-fmt，那是 nixpkgs 仓库专用）
--  系统需装：pkgs.nixd + pkgs.nixfmt-rfc-style（或 nixfmt）
vim.lsp.config('nixd', {
  settings = {
    nixd = {
      formatting = { command = { 'nixfmt' } },
    },
  },
})

-- ---------- keymaps（LSP 缓冲生效）----------
local on_attach = function(_, bufnr)
  local bufmap = function(lhs, rhs, desc)
    -- desc 是 string：vim.keymap.set 的 opts 是 buffer + desc
    vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end
  bufmap('gd', vim.lsp.buf.definition, '跳到定义')
  bufmap('gr', vim.lsp.buf.references, '跳到引用')
  bufmap('gD', vim.lsp.buf.declaration, '跳到声明')
  bufmap('gi', vim.lsp.buf.implementation, '跳到实现')
  bufmap('K', vim.lsp.buf.hover, '悬停文档')
  bufmap('<leader>rn', vim.lsp.buf.rename, '重命名')
  bufmap('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
  bufmap(']d', function() vim.diagnostic.jump({ count = 1 }) end, '下一诊断')
  bufmap('[d', function() vim.diagnostic.jump({ count = -1 }) end, '上一诊断')
  bufmap('<leader>e', vim.diagnostic.open_float, '诊断详情')
  bufmap('<leader>fm', function() vim.lsp.buf.format({ async = false }) end, 'LSP 格式化')
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    on_attach(ev.data.client, ev.buf)
  end,
})

-- ---------- 保存时自动格式化 ----------
--  Lua → lua_ls 调 stylua
--  Python → pyright 不提供格式化，需装 black
--  JS/TS → tsserver 不提供格式化，需装 prettier
--  Go → gopls 不提供格式化，需装 gofmt/goimports
--  Rust → rust-analyzer 不提供格式化，需装 rustfmt
--
--  不喜欢可注释掉：保留手动 <leader>fm
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('LspAutoFormat', { clear = true }),
  callback = function(ev)
    -- 仅 LSP buffer；排除只读、help、git commit 等特殊文件
    local ft = vim.bo[ev.buf].filetype
    if vim.tbl_contains({ 'help', 'gitcommit', 'gitrebase', 'hgcommit', 'diff' }, ft) then return end
    -- 仅当 buffer 至少附着了一个 LSP
    if #vim.lsp.get_clients({ bufnr = ev.buf }) > 0 then
      -- sync 等待 format 完成才让 write 继续，避免 race condition
      -- async=true 会让文件已写入后再被 format 覆盖，复杂且不靠谱
      pcall(function() vim.lsp.buf.format({ async = false, bufnr = ev.buf }) end)
    end
  end,
})

