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

--[[
if pcall(vim.cmd.packadd, "lsp-zero") then
    pcall(vim.cmd.packadd, "nvim-lspconfig") -- +
    pcall(vim.cmd.packadd, "mason") -- +
    pcall(vim.cmd.packadd, "mason-lspconfig") -- +
    pcall(vim.cmd.packadd, "mason-null-ls")
    pcall(vim.cmd.packadd, "nvim-cmp") -- +
    pcall(vim.cmd.packadd, "cmp-nvim-lsp") -- +
    pcall(vim.cmd.packadd, "cmp-buffer") -- +
    pcall(vim.cmd.packadd, "cmp-path") -- +
    pcall(vim.cmd.packadd, "LuaSnip") -- +
    pcall(vim.cmd.packadd, "cmp-nvim-lua") -- +
    pcall(vim.cmd.packadd, "null-ls")

    local lsp = require("lsp-zero").preset({
        name = "recommended",
    })
    lsp.nvim_workspace()
    lsp.configure("volar", {
        on_init = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentFormattingRangeProvider = false
        end,
    })
    lsp.setup()

    -- See mason-null-ls.nvim's documentation for more details:
    -- https://github.com/jay-babu/mason-null-ls.nvim#setup
    require("mason-null-ls").setup({
        automatic_installation = false, -- You can still set this to `true`
        handlers = {},
    })

    local null_ls = require("null-ls")
    local null_opts = lsp.build_options("null-ls", {})

    null_ls.setup({
        on_attach = function(client, bufnr)
            null_opts.on_attach(client, bufnr)
        end,
        sources = {
            -- You can add tools not supported by mason.nvim
        },
    })
end
--]]
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

        -- setup cmp
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
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
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),
            sources = cmp.config.sources(sources),
        })
    end
end

if lspconfig then
    local function lsp_attach(_, bufnr)
        local nmap = function(keys, func, desc)
            if desc then
                desc = "LSP: " .. desc
            end
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        nmap("<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")
        -- Create a command `:Format` local to the LSP buffer
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
