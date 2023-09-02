-- ┌─┐┌┬┐┬┌┬┐┌─┐┬─┐  ┌─┐┌─┐┌┬┐┌┬┐┬┌┐┌┌─┐┌─┐
-- ├┤  │││ │ │ │├┬┘  └─┐├┤  │  │ │││││ ┬└─┐
-- └─┘─┴┘┴ ┴ └─┘┴└─  └─┘└─┘ ┴  ┴ ┴┘└┘└─┘└─┘

-- Map <leader> to space
vim.g.mapleader = " "
-- Map <localleader> to comma
vim.g.maplocalleader = "\\"

-- Add russian language keymap (switch using CTRL+SHFT+6 in insert mode)
vim.o.keymap = "russian-jcukenwin"
vim.o.iminsert = 0
vim.o.imsearch = 0

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
vim.opt.signcolumn = "number"

-- In many terminal emulators the mouse works just fine, thus enable it.
vim.opt.mouse = "a"

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

lazy.setup({
    -- Theming
    { "catppuccin/nvim" },
    { "nvim-tree/nvim-web-devicons" },
    -- Utilities
    { "nvim-lua/plenary.nvim" },
    -- Fuzzy finder
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    -- Code manipulation
    { "nvim-treesitter/nvim-treesitter" },
    { "fatih/vim-go" },
    -- LSP Support
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    -- Autocomplete
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "zbirenbaum/copilot.lua" },
    { "zbirenbaum/copilot-cmp" },
    { "L3MON4D3/LuaSnip" },
})

-- ┌─┐┬  ┬ ┬┌─┐┬┌┐┌  ┌─┐┌─┐┌┐┌┌─┐┬┌─┐┬ ┬┬─┐┌─┐┌┬┐┬┌─┐┌┐┌
-- ├─┘│  │ ││ ┬││││  │  │ ││││├┤ ││ ┬│ │├┬┘├─┤ │ ││ ││││
-- ┴  ┴─┘└─┘└─┘┴┘└┘  └─┘└─┘┘└┘└  ┴└─┘└─┘┴└─┴ ┴ ┴ ┴└─┘┘└┘

-- Set catppuccin theme
require("catppuccin").setup({ term_colors = true })
vim.cmd.colorscheme("catppuccin-mocha")

-- Setup TreeSitter
require("nvim-treesitter.configs").setup({
    auto_install = true,
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = false },
})

-- Setup vim-go
vim.g.go_fmt_command = "goimports"

-- Setup Telescope
require("telescope").setup({
    defaults = {
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
})
require("telescope").load_extension("live_grep_args")
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, {})
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, {})
vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

-- Setup copilot
require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
})
require("copilot_cmp").setup()

-- Setup nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
        documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "buffer" },
        { name = "copilot" },
    }),
    sorting = {
        priority_weight = 2,
        comparators = {
            require("copilot_cmp.comparators").prioritize,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})

-- LSP Config
local lspconfig = require("lspconfig")
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local lsp_capabilities = vim.tbl_deep_extend("force", lspconfig.util.default_config, cmp_capabilities)

-- LSP Servers
require("mason").setup({
    ui = { border = "rounded" },
})
require("mason-lspconfig").setup({
    handlers = {
        function(server_name)
            lspconfig[server_name].setup({ capabilities = lsp_capabilities })
        end,
        ["lua_ls"] = function()
            lspconfig["lua_ls"].setup({
                capabilities = lsp_capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
        end,
    },
})

-- LSP Keybindings
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "LSP actions",
    callback = function()
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true, desc = "Hover Documentation" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true, desc = "Goto Definition" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = true, desc = "Goto Declaration" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = true, desc = "Goto Implementation" })
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { buffer = true, desc = "Goto Type Definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = true, desc = "Goto References" })
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = true, desc = "Signature Documentation" })
        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = true, desc = "Rename" })
        vim.keymap.set("n", "<F3>", vim.lsp.buf.format, { buffer = true, desc = "Format" })
        vim.keymap.set("x", "<F3>", vim.lsp.buf.format, { buffer = true, desc = "Format" })
        vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, { buffer = true, desc = "Code Action" })

        local visual_code_action = vim.lsp.buf.range_code_action or vim.lsp.buf.code_action
        vim.keymap.set("x", "<F4>", visual_code_action, { buffer = true, desc = "Code Action" })
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = true, desc = "Show diagnostics" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = true, desc = "Previous diagnostics" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = true, desc = "Next diagnostics" })
    end,
})

-- Diagnostic Customization
vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "", numhl = "" })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focused = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})
