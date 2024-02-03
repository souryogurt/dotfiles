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
end

return plugin
