return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        sources = { "filesystem" },
        hide_root_node = true,              -- Hide the root node.
        open_files_do_not_replace_types = { -- when opening files, do not use windows containing these filetypes or buftypes
            "terminal",
            "Trouble",
            "qf",
            "edgy",
        },
        popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)
        local toggle_focus = function()
            if vim.bo.filetype == "neo-tree" then
                vim.cmd("wincmd p")
            else
                vim.cmd("Neotree focus")
            end
        end
        vim.keymap.set('n', '<leader>e', ':Neotree toggle<cr>',
            { noremap = true, silent = true, desc = "Toggle Explorer" })
        vim.keymap.set('n', '<leader>o', toggle_focus,
            { noremap = true, silent = true, desc = "Toggle Explorer Focus" })
    end
}
