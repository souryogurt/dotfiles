local plugin = { "fatih/vim-go" }

plugin.ft = "go"

plugin.enabled = false

function plugin.config()
    vim.g.go_fmt_command = "goimports"
end

return plugin
