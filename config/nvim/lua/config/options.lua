-- ============================================================================
--  全局编辑选项
-- ============================================================================

local opt          = vim.opt

-- ---------- 缩进 ----------
opt.expandtab      = true -- tab 转空格
opt.shiftwidth     = 4 -- 缩进宽度
opt.tabstop        = 4 -- tab 显示宽度
opt.smartindent    = true -- 新行自动缩进

-- ---------- 搜索 ----------
opt.ignorecase     = true -- 搜索忽略大小写
opt.smartcase      = true -- 含大写时精确匹配
opt.incsearch      = true -- 增量搜索
opt.hlsearch       = true -- 高亮搜索结果
opt.showmatch      = true -- 匹配括号闪烁
opt.matchtime      = 2

-- ---------- 行号 / 光标 ----------
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = 'yes:1' -- 给 gitsigns / LSP 留位置（始终 1 列）

-- ---------- 外观 ----------
opt.colorcolumn    = '100' -- 第 100 列高亮
opt.scrolloff      = 8    -- 距顶/底 8 行开始滚动
opt.sidescrolloff  = 8
opt.wrap           = false -- 不自动换行
opt.linebreak      = true -- 按单词换行
opt.breakindent    = true -- 换行后保持缩进
opt.showmode       = false -- 状态栏会显示模式
opt.confirm        = true -- :q 等命令不会因 unsaved 失败
opt.termguicolors  = true

-- ---------- 剪贴板 / 鼠标 ----------
opt.clipboard      = 'unnamedplus' -- 与系统剪贴板互通

-- ---------- 补全（0.12 内置）----------
opt.completeopt    = { 'menu', 'menuone', 'noselect' }
