return {
    "epwalsh/obsidian.nvim",
    lazy = true,
    cmd = {
        "ObsidianOpen",
        "ObsidianNew",
        "ObsidianQuickSwitch",
        "ObsidianFollowLink",
        "ObsidianToday",
        "ObsidianYesterday",
        "ObsidianTemplate",
        "ObsidianSearch",
        "ObsidianLink",
        "ObsidianLinkNew",
        "ObsidianWorkspace",
    },
    event = {
        -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        "BufReadPre "
            .. vim.fn.expand("~")
            .. "/documents/Insight/**.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/documents/Insight/**.md",
    },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",

        -- see below for full list of optional dependencies 👇
    },
    opts = {
        workspaces = {
            {
                name = "Insight",
                path = "~/documents/Insight",
            },
        },
        disable_frontmatter = true,
        daily_notes = {
            folder = "Daily",
        },
        completion = {
            nvim_cmp = true,
            new_notes_location = "notes_subdir",
        },
    },
}
