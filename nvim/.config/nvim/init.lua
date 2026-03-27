-- ┌─┐┌┬┐┬┌┬┐┌─┐┬─┐  ┌─┐┌─┐┌┬┐┌┬┐┬┌┐┌┌─┐┌─┐
-- ├┤  │││ │ │ │├┬┘  └─┐├┤  │  │ │││││ ┬└─┐
-- └─┘─┴┘┴ ┴ └─┘┴└─  └─┘└─┘ ┴  ┴ ┴┘└┘└─┘└─┘

-- Map <leader> to space
vim.g.mapleader = " "
-- Map <localleader> to comma
vim.g.maplocalleader = "\\"

vim.opt.clipboard:append("unnamedplus")
-- Add russian language keymap (switch using CTRL+L in insert mode)
vim.o.keymap = "russian-jcukenwin"
vim.o.iminsert = 0
vim.o.imsearch = 0
vim.keymap.set("i", "<C-l>", "<C-^>", { noremap = true, silent = true, desc = "Switch keyboard layout (Insert mode)" })

-- Number of screen lines to keep above and below the cursor
vim.o.scrolloff = 5

-- Undo and backup options
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.swapfile = false

-- Better buffer splitting
vim.o.splitright = true
vim.o.splitbelow = true

-- show diagnostic signs on the number column
vim.opt.signcolumn = "yes"
vim.opt_local.cursorline = true
vim.opt_local.cursorlineopt = "line,number"

-- use relative numbers
vim.opt.relativenumber = true

-- In many terminal emulators the mouse works just fine, thus enable it.
vim.opt.mouse = "a"

-- Hide the cmdline in normal mode
vim.opt.cmdheight=0

-- Shortcuts
vim.keymap.set({ "n", "v", "o" }, "Q", "gq", { desc = "Format code" })

-- ┌─┐┌─┐┌┬┐┌┬┐┌─┐┌┐┌┌┬┐┌─┐
-- │  │ │││││││├─┤│││ ││└─┐
-- └─┘└─┘┴ ┴┴ ┴┴ ┴┘└┘─┴┘└─┘

local group = vim.api.nvim_create_augroup("user_cmds", { clear = true })

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd("FocusGained", {
    desc = "Check if the file must be reloaded",
    group = group,
    command = "checktime",
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight on yank",
    callback = function()
        vim.highlight.on_yank()
    end,
    group = group,
    pattern = "*",
})

-- ┌─┐┬  ┬ ┬┌─┐┬┌┐┌┌─┐
-- ├─┘│  │ ││ ┬││││└─┐
-- ┴  ┴─┘└─┘└─┘┴┘└┘└─┘

local lazy = {}

function lazy.install(path)
    if not vim.loop.fs_stat(path) then
        print("Installing lazy.nvim....")
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            path,
        })
    end
end

function lazy.setup(plugins)
    lazy.install(lazy.path)
    vim.opt.rtp:prepend(lazy.path)
    require("lazy").setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
lazy.opts = {
    defaults = {
        -- Make all plugins lazy-loaded by default.
        -- lazy = true,
        -- Always use the latest git commit to load plugins.
        version = false,
    },
    install = { missing = true, colorscheme = { "catppuccin" } },
    -- Automatically check for plugin updates on startup.
    checker = { enabled = false },
    ui = {
        border = "rounded",
        title = " Lazy ",
    },
    change_detection = {
        notify = false,
    },
    performance = {
        rtp = {
            -- Disable some rtp plugins
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
}

lazy.setup({ { import = "plugins" } })
