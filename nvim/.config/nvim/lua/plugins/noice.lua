return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
        presets = {
            command_palette = true,       -- position the cmdline and popupmenu together
            bottom_search = true,         -- use a classic bottom cmdline for search
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false,           -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
        lsp = {
            -- override markdown rendering so that cmp and other plugins use Treesitter
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "written",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = "Finished loading packages.",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = "initializing gopls",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    find = "initialized gopls",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    find = "definition] SUCCESS",
                },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    kind = "search_count",
                },
                opts = { skip = true },
            },
        },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    }
}
