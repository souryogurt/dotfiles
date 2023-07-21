-- General settings

local g = vim.g
local o = vim.o
local opt = vim.opt

-- Map <leader> to space
g.mapleader = " "

-- Add russian language keymap (switch using CTRL+SHFT+6 in insert mode)
o.keymap = "russian-jcukenwin"
o.iminsert = 0
o.imsearch = 0

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
        auto_install = true,
        highlight = { enable = true },
        incremental_selection = { enable = true },
        indent = { enable = false },
    })
end

if pcall(vim.cmd.packadd, "plenary") then
    pcall(vim.cmd.packadd, "nvim-web-devicons")
    if pcall(vim.cmd.packadd, "telescope") then
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
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        if pcall(vim.cmd.packadd, "telescope-live-grep-args") then
            require("telescope").load_extension("live_grep_args")
            vim.keymap.set(
                "n",
                "<leader>fg",
                ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>"
            )
        else
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        end
    end
end

if pcall(vim.cmd.packadd, "copilot.lua") then
    require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
    })
end

local lspconfig
local lsp_capabilities = {}
if pcall(vim.cmd.packadd, "nvim-lspconfig") then
    lspconfig = require("lspconfig")
end

if pcall(vim.cmd.packadd, "LuaSnip") then
    if pcall(vim.cmd.packadd, "nvim-cmp") then
        local luasnip = require("luasnip")
        local cmp = require("cmp")
        local sources = {}

        -- setup sources
        if lspconfig and pcall(vim.cmd.packadd, "cmp-nvim-lsp") then
            table.insert(sources, { name = "nvim_lsp" })
            local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
            lsp_capabilities = vim.tbl_deep_extend("force", lsp_capabilities, cmp_capabilities)
        end
        if pcall(vim.cmd.packadd, "cmp-nvim-lua") then
            table.insert(sources, { name = "nvim_lua" })
        end
        if pcall(vim.cmd.packadd, "cmp-path") then
            table.insert(sources, { name = "path" })
        end
        if pcall(vim.cmd.packadd, "cmp-buffer") then
            table.insert(sources, { name = "buffer" })
        end
        if pcall(vim.cmd.packadd, "copilot-cmp") then
            require("copilot_cmp").setup()
            table.insert(sources, { name = "copilot" })
        end

        -- setup cmp
        local border_ops = {
            border = "single",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(border_ops),
                documentation = cmp.config.window.bordered(border_ops),
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
            sources = cmp.config.sources(sources),
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
    end
end

if lspconfig then
    local function lsp_attach(_, bufnr)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Goto Definition" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Goto Declaration" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Goto Implementation" })
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Goto Type Definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Goto References" })
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Documentation" })
        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
        vim.keymap.set("n", "<F3>", vim.lsp.buf.format, { buffer = bufnr, desc = "Format" })
        vim.keymap.set("x", "<F3>", vim.lsp.buf.format, { buffer = bufnr, desc = "Format" })
        vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })

        local visual_code_action = vim.lsp.buf.range_code_action or vim.lsp.buf.code_action
        vim.keymap.set("x", "<F4>", visual_code_action, { buffer = bufnr, desc = "Code Action" })
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show diagnostics" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostics" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostics" })

        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
            vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
    end

    local mason
    if pcall(vim.cmd.packadd, "mason") then
        mason = require("mason")
        mason.setup()
    end
    if mason and pcall(vim.cmd.packadd, "mason-lspconfig") then
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup()
        mason_lspconfig.setup_handlers({
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function(server_name)
                lspconfig[server_name].setup({
                    on_attach = lsp_attach,
                    capabilities = lsp_capabilities,
                })
            end,
            -- Next, you can provide a dedicated handler for specific servers.
            ["lua_ls"] = function()
                lspconfig["lua_ls"].setup({
                    on_attach = lsp_attach,
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
        })
    else
        -- setup lspconfig manually
        -- lspconfig["tsserver"].setup({
        --     on_attach = lsp_attach,
        --     capabilities = lsp_capabilities,
        -- })
    end
end

-- Can be none/single/double/rounded/solid/shadow
local border = "rounded"
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focused = false, -- no such parameter, maybe "focasable" ?
        style = "minimal", -- probably no such parameter
        border = border, -- none/single/double/rounded/solid/shadow
        source = true, -- "if_many" to show the source only if many sources
        header = "",
        prefix = "",
    },
})
vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "", numhl = "" })

if pcall(vim.cmd.packadd, "vim-go") then
    g.go_fmt_command = "goimports"
end
