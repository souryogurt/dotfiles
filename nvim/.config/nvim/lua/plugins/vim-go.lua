local plugin = { "fatih/vim-go" }

plugin.ft = "go"

function plugin.config()
    vim.g.go_fmt_command = "goimports"
end

return plugin
