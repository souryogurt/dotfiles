local plugin = { "neovim/nvim-lspconfig" }

local user = {}

plugin.dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "williamboman/mason-lspconfig.nvim", lazy = true },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        lazy = true,
        config = function()
            user.setup_mason()
        end,
    },
}

plugin.cmd = {
    "LspInfo",
    "LspInstall",
    "LspLog",
    "LspRestart",
    "LspStart",
    "LspStop",
    "LspUninstall",
}

plugin.event = { "BufReadPre", "BufNewFile" }

function plugin.init()
    vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "", numhl = "" })
    vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "", numhl = "" })
    vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "", numhl = "" })
    vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "", numhl = "" })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
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
end

function plugin.config()
    local lspconfig = require("lspconfig")
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lsp_capabilities = vim.tbl_deep_extend("force", lspconfig.util.default_config, cmp_capabilities)

    local group = vim.api.nvim_create_augroup("lsp_cmds", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        desc = "LSP actions",
        callback = user.on_attach,
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
            ["grammarly"] = function()
                lspconfig["grammarly"].setup({
                    capabilities = lsp_capabilities,
                    cmd = {
                        "n",
                        "run",
                        "16",
                        require("mason-core.path").bin_prefix("grammarly-languageserver"),
                        "--stdio",
                    },
                    init_options = {
                        client_id = "client_BaDkMgx4X19X9UxxYRCXZo",
                    },
                })
            end,
        },
    })
end

function user.on_attach()
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
end

function user.setup_mason()
    require("mason").setup({
        ui = { border = "rounded" },
    })
end

return plugin
