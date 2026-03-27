return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        sources = { "filesystem", "git_status"},
        source_selector = {
            statusline = true,
        },
        default_source = "last",
        hide_root_node = true,              -- Hide the root node.
        close_if_last_window = true,        -- Close Neo-tree if it is the last window left in the tab
        open_files_do_not_replace_types = { -- when opening files, do not use windows containing these filetypes or buftypes
            "terminal",
            "Trouble",
            "qf",
            "edgy",
        },
        popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
        window = {
            position = "right", -- "float" is awesome too
        },
        filesystem = {
            follow_current_file = {
                enabled = true,
            },
        },
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
