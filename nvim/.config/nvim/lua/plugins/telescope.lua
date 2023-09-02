local plugin = { "nvim-telescope/telescope.nvim" }

plugin.dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
}

plugin.keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
    { "<leader>fw", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", desc = "Find words" },
    {
        "<leader>fc",
        ":lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<CR>",
        desc = "Find for word under cursor",
    },
    { "<leader>f<CR>", "<cmd>Telescope resume<CR>", desc = "Resume previous search" },
    { "<leader>f'", "<cmd>Telescope marks<CR>", desc = "Find marks" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
    { "<leader>fm", "<cmd>Telescope man_pages<CR>", desc = "Find man" },
}

plugin.opts = {
    defaults = {
        sorting_strategy = "ascending", -- Fixes bug in nightly neovim
        layout_strategy = "flex",
        layout_config = {
            height = 0.95,
            width = 0.854328011,
            flip_columns = 131,
            vertical = {
                preview_height = 0.618033,
            },
            horizontal = {
                preview_width = 0.618033,
            },
        },
    },
}

plugin.cmd = { "Telescope" }

function plugin.config(_, opts)
    require("telescope").load_extension("live_grep_args")
    require("telescope").setup(opts or {})
end

return plugin
