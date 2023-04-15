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

if pcall(vim.cmd.packadd, "lsp-zero") then
    pcall(vim.cmd.packadd, "nvim-lspconfig") -- +
    pcall(vim.cmd.packadd, "mason") -- +
    pcall(vim.cmd.packadd, "mason-lspconfig") -- +
    pcall(vim.cmd.packadd, "mason-null-ls")
    pcall(vim.cmd.packadd, "nvim-cmp") -- +
    pcall(vim.cmd.packadd, "cmp-nvim-lsp") -- +
    pcall(vim.cmd.packadd, "cmp-buffer")
    pcall(vim.cmd.packadd, "cmp-path")
    pcall(vim.cmd.packadd, "LuaSnip")
    pcall(vim.cmd.packadd, "cmp-nvim-lua")

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

if pcall(vim.cmd.packadd, "nvim-lspconfig") then
    local lspconfig = require("lspconfig")
    if pcall(vim.cmd.packadd, "nvim-cmp") then
        local cmp = require("cmp")
        local sources = {}
        if pcall(vim.cmd.packadd, "cmp-nvim-lsp") then
            table.insert(sources, { name = "nvim_lsp" })
            local function lsp_attach(client, bufnr)
                -- TODO: Create your keybindings here
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

                -- See `:help K` for why this keymap
                nmap("K", vim.lsp.buf.hover, "Hover Documentation")
                nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

                -- Lesser used LSP functionality
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
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
            if pcall(vim.cmd.packadd, "mason") then
                require("mason").setup()
                if pcall(vim.cmd.packadd, "mason-lspconfig") then
                    local mason_lspconfig = require("mason-lspconfig")
                    mason_lspconfig.setup()
                    mason_lspconfig.setup_handlers({
                        function(server_name)
                            lspconfig[server_name].setup({
                                on_attach = lsp_attach,
                                capabilities = lsp_capabilities,
                            })
                        end,
                    })
                end
            else
                -- setup lspconfig manually
            end
        end

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup({
            sources = sources,
            mapping = cmp.mapping.preset.insert({
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                --["<C-Space>"] = cmp.mapping.complete({}),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),

                ["<C-Space>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                }),

                ["<Tab>"] = function(fallback)
                    if not cmp.select_next_item() then
                        if vim.bo.buftype ~= "prompt" and has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end
                end,

                ["<S-Tab>"] = function(fallback)
                    if not cmp.select_prev_item() then
                        if vim.bo.buftype ~= "prompt" and has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end
                end,
            }),
            snippet = {
                -- We recommend using *actual* snippet engine.
                -- It's a simple implementation so it might not work in some of the cases.
                expand = function(args)
                    unpack = unpack or table.unpack
                    local line_num, col = unpack(vim.api.nvim_win_get_cursor(0))
                    local line_text = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, true)[1]
                    local indent = string.match(line_text, "^%s*")
                    local replace = vim.split(args.body, "\n", true)
                    local surround = string.match(line_text, "%S.*") or ""
                    local surround_end = surround:sub(col)

                    replace[1] = surround:sub(0, col - 1) .. replace[1]
                    replace[#replace] = replace[#replace] .. (#surround_end > 1 and " " or "") .. surround_end
                    if indent ~= "" then
                        for i, line in ipairs(replace) do
                            replace[i] = indent .. line
                        end
                    end

                    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, true, replace)
                end,
            },
        }, {
            { name = "buffer" },
        })
    else
    end
end
