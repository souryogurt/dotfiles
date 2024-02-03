local plugin = { "folke/which-key.nvim" }

plugin.event = "VeryLazy"

function plugin.init()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
end

function plugin.config()
    local wk = require("which-key")
    wk.setup({
        show_help = false,
        window = {
            border = "rounded",
        },
    })
    wk.register({
        f = { name = "+Find", desc = "Find" },
    }, { prefix = "<leader>" })
    wk.register({
        t = { name = "+Table", desk = "Table" },
    }, { prefix = "<leader>" })

    vim.keymap.set('n', '<leader><Left>', '<C-w>h',
        { noremap = true, silent = true, desc = "Move to left window" })
    vim.keymap.set('n', '<leader><Down>', '<C-w>j',
        { noremap = true, silent = true, desc = "Move to down window" })
    vim.keymap.set('n', '<leader><Up>', '<C-w>k',
        { noremap = true, silent = true, desc = "Move to up window" })
    vim.keymap.set('n', '<leader><Right>', '<C-w>l',
        { noremap = true, silent = true, desc = "Move to right window" })
end

return plugin
