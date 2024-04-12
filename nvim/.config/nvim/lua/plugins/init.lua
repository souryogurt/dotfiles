return {
    -- Theming
    {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                term_colors = true,
                integrations = {
                    mason = true,
                    noice = true,
                    neotree = true,
                    which_key = true,
                },
            })
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
        priority = 1000,
    },
    { "nvim-tree/nvim-web-devicons" },
}
