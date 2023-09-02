local plugin = { "nvim-treesitter/nvim-treesitter" }

plugin.build = ":TSUpdate"
plugin.event = "BufReadPost"
plugin.cmd = "TSInstall"
plugin.opts = {
    auto_install = true,
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = false },
}
function plugin.config(_, opts)
    require("nvim-treesitter.configs").setup(opts)
end

return plugin
