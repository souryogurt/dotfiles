return {
  "ray-x/go.nvim",
  dependencies = {  -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lsp_capabilities = vim.tbl_deep_extend("force", lspconfig.util.default_config, cmp_capabilities)
    require("go").setup({
        lsp_cfg = {
            capabilities = lsp_capabilities,
            settings = {
                gopls = {
                    analyses = {
                        ST1003 = false,
                    },
                },
            },
        },
        lsp_keymaps = false,
        diagnostic = false,
        lsp_inlay_hints = {
            enable = false,
        },
    })
    local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
            require('go.format').goimport()
        end,
        group = format_sync_grp,
    })
    vim.keymap.set('n', '<F10>', ':GoTestFile<cr>',
    { noremap = true, silent = true, desc = "Run go tests on current file" })
  end,
  event = {"CmdlineEnter"},
  ft = {"go", 'gomod'},
  build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}
