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

vim.keymap.set({ "n", "v", "o" }, "Q", "gq", { desc = "Format code" })

-- Set catppuccin theme if installed
if pcall(vim.cmd.packadd, "catppuccin") then
    require("catppuccin").setup({ term_colors = true })
    vim.cmd.colorscheme("catppuccin-mocha")
end

if pcall(vim.cmd.packadd, "nvim-treesitter") then
    require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        incremental_selection = { enable = true },
        indent = { enable = false },
    })
end

if pcall(vim.cmd.packadd, "plenary") then
    pcall(vim.cmd.packadd, "nvim-web-devicons")
    if pcall(vim.cmd.packadd, "telescope") then
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        if pcall(vim.cmd.packadd, "telescope-live-grep-args") then
            require("telescope").load_extension("live_grep_args")
            vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
        else
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        end
    end
end

if pcall(vim.cmd.packadd, "lsp-zero") then
    pcall(vim.cmd.packadd, "nvim-lspconfig")
    pcall(vim.cmd.packadd, "mason")
    pcall(vim.cmd.packadd, "mason-lspconfig")
    pcall(vim.cmd.packadd, "mason-null-ls")
    pcall(vim.cmd.packadd, "nvim-cmp")
    pcall(vim.cmd.packadd, "cmp-nvim-lsp")
    pcall(vim.cmd.packadd, "cmp-buffer")
    pcall(vim.cmd.packadd, "cmp-path")
    pcall(vim.cmd.packadd, "LuaSnip")
    pcall(vim.cmd.packadd, "cmp-nvim-lua")

    pcall(vim.cmd.packadd, "null-ls")

    local lsp = require("lsp-zero").preset({
        name = "recommended",
    })
    lsp.nvim_workspace()
    lsp.configure('volar', {
        on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentFormattingRangeProvider = false
        end,
    })
    lsp.setup()

    local null_ls = require('null-ls')
    local null_opts = lsp.build_options('null-ls', {})

    null_ls.setup({
        on_attach = function(client, bufnr)
            null_opts.on_attach(client, bufnr)
        end,
        sources = {
            -- You can add tools not supported by mason.nvim
        }
    })

    -- See mason-null-ls.nvim's documentation for more details:
    -- https://github.com/jay-babu/mason-null-ls.nvim#setup
    require('mason-null-ls').setup({
        automatic_installation = false, -- You can still set this to `true`
        automatic_setup = true,
    })

    -- Required when `automatic_setup` is true
    require('mason-null-ls').setup_handlers()
end
