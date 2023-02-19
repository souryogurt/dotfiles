-- General settings

local g = vim.g
local o = vim.o
local opt = vim.opt

-- Map <leader> to space
g.mapleader = " "

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 5

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

-- show diagnostic signs on the number column
opt.signcolumn = "number"

-- In many terminal emulators the mouse works just fine, thus enable it.
opt.mouse = "a"

-- Set catppuccin theme if installed
if pcall(vim.cmd.packadd, "catppuccin") then
    require("catppuccin").setup({ term_colors = true })
    vim.cmd.colorscheme("catppuccin-mocha")
end

if pcall(vim.cmd.packadd, "nvim-treesitter") then
    require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        incremental_selection = { enable = true },
        indent = { enable = true },
    })
end

if pcall(vim.cmd.packadd, "plenary") then
    pcall(vim.cmd.packadd, "nvim-web-devicons")
    if pcall(vim.cmd.packadd, "telescope") then
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end
end

if pcall(vim.cmd.packadd, "lsp-zero.nvim") then
    pcall(vim.cmd.packadd, "nvim-lspconfig")
    pcall(vim.cmd.packadd, "mason.nvim")
    pcall(vim.cmd.packadd, "mason-lspconfig.nvim")
    pcall(vim.cmd.packadd, "nvim-cmp")
    pcall(vim.cmd.packadd, "cmp-nvim-lsp")
    pcall(vim.cmd.packadd, "cmp-buffer")
    pcall(vim.cmd.packadd, "cmp-path")
    pcall(vim.cmd.packadd, "LuaSnip")
    pcall(vim.cmd.packadd, "cmp-nvim-lua")
    local lsp = require("lsp-zero").preset({
        name = "recommended",
    })
    lsp.nvim_workspace()
    lsp.setup()
end
