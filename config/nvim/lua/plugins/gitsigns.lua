-- ============================================================================
--  gitsigns.nvim — Git 集成
-- ============================================================================
--  打开 git 仓库的文件后，行号旁自动显示改动标记:
--    + 新增（绿）  ~ 修改（黄）  - 删除（红）  ? 未跟踪（灰）
--
--  完整工作流:
--    1. 改代码        → 行号旁出现标记
--    2. ]h / [h       → 跳到下/上一处改动
--    3. <leader>gp    → 弹窗看 diff
--    4. <leader>gs    → 暂存这个 hunk（git add -p 等价）
--    5. <leader>gu    → 取消暂存
--    6. <leader>gr    → 回滚这个 hunk（救命）
--    7. <leader>gb    → blame 当前行（谁改的、什么时候）
--    8. <leader>gd    → 整文件对比 HEAD
-- ============================================================================

require('gitsigns').setup({
    -- gutter 标记（左侧小条字符）
    signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '≃' },
        untracked    = { text = '?' },
    },
    signs_staged_enable = true,  -- 已暂存的也显示
    signcolumn          = true,  -- 给 gutter 留位置
    numhl               = false, -- 改动行的行号不高亮（避免太花）
    linehl              = false, -- 改动行整行不高亮
    word_diff           = false, -- 行内 word-level diff（关闭，更快）
    watch_gitdir        = { follow_files = true },
    attach_to_untracked = false,
    current_line_blame  = false,            -- 关闭（按需 :Gitsigns toggle_current_line_blame 打开）
    update_debounce     = 100,
    preview_config = {
        border   = 'rounded',
        style    = 'minimal',
        relative = 'cursor',
        row      = 0,
        col      = 1,
    },
})

-- ---------- 快捷键 ----------
local gs = require('gitsigns')
local map = vim.keymap.set

-- 跳转
map('n', ']h', function() gs.next_hunk() end, { desc = '下一 hunk' })
map('n', '[h', function() gs.prev_hunk() end, { desc = '上一 hunk' })

-- 查看 diff
map('n', '<leader>gp', gs.preview_hunk,        { desc = '预览 hunk (diff)'   })
map('n', '<leader>gb', function() gs.blame_line({ full = true }) end,
                                                  { desc = 'blame 当前行'        })

-- 整文件 vs HEAD 对比（打开一个新 buffer 看完整 diff）
map('n', '<leader>gd', function() gs.diffthis('HEAD') end,
                                                  { desc = '整文件对比 HEAD'      })

-- 暂存 / 取消暂存 / 回滚
map('n', '<leader>gs', gs.stage_hunk,          { desc = '暂存 hunk (git add)'  })
map('n', '<leader>gu', gs.undo_stage_hunk,     { desc = '取消暂存'             })
map('n', '<leader>gr', gs.reset_hunk,          { desc = '回滚 hunk（救命）'    })

-- 可视模式下：只对选中部分操作
map('v', '<leader>gs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                                                  { desc = '暂存选中范围'         })
map('v', '<leader>gr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                                                  { desc = '回滚选中范围'         })

-- 文本对象：ih = inner hunk（光标必须在 hunk 内）
map('o', 'ih', ':<C-U>execute "Gitsigns select_hunk"<CR>', { desc = '选中 hunk 内部' })
map('o', 'ah', ':<C-U>execute "Gitsigns select_hunk"<CR>', { desc = '选中整个 hunk'  })

-- 整 buffer 操作（一次性 stage/reset 整个文件）
-- map('n', '<leader>gS', gs.stage_buffer,    { desc = '暂存整个 buffer'   })
-- map('n', '<leader>gR', gs.reset_buffer,    { desc = '回滚整个 buffer'   })
-- 用得少，先注释掉