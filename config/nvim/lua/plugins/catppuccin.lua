-- ============================================================================
--  Catppuccin 主题
-- ============================================================================
--  可选变体：frappe / mocha / macchiato / latte
--  切换：改下面的 flavour，并改最后一行 vim.cmd.colorscheme(...)
-- ============================================================================

require('catppuccin').setup({
    flavour = 'frappe',
    background = {
        dark  = 'frappe',
        light = 'latte',
    },
    transparent_background = false,
    term_colors             = true,
    integrations = {
        cmp        = true,   -- blink.cmp 也会被识别
        gitsigns   = true,
        treesitter = true,
        notify     = true,
        native_lsp = {
            enabled      = true,
            virtual_text = { errors = 'italic', hints = 'italic', warnings = 'italic', information = 'italic' },
            underlines  = { errors = 'underline', hints = 'underline', warnings = 'underline', information = 'underline' },
        },
    },
})

vim.cmd.colorscheme('catppuccin-frappe')