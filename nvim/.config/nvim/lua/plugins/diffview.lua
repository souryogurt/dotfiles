local plugin = { "sindrets/diffview.nvim" }

plugin.cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
}

plugin.dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
}

plugin.keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git diff view" },
    { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Git diff close" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git file history" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Git repo history" },
}

plugin.opts = {
    enhanced_diff_hl = true,
    use_icons = true,
}

function plugin.config(_, opts)
    require("diffview").setup(opts)
end

return plugin
