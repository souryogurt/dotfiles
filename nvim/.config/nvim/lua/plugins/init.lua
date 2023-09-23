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
                custom_highlights = function(colors)
                    return {
                        ChatGPTQuestion = { fg = colors.saphire },
                        ChatGPTWelcome = { fg = colors.overlay1 },
                        ChatGPTTotalTokens = { fg = colors.crust, bg = colors.blue },
                        ChatGPTTotalTokensBorder = { fg = colors.blue },
                        ChatGPTMessageAction = { fg = colors.crust, bg = colors.blue },
                        ChatGPTCompletion = { fg = colors.text },
                        FloatBorder = { bg = colors.base }
                    }
                end
            })
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
        priority = 1000,
    },
    { "nvim-tree/nvim-web-devicons" },
}
