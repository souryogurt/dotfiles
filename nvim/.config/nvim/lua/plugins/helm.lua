return {
    "towolf/vim-helm",
    init = function()
        local function helm_ft(path, _)
            -- check if file is in templates folder or is helmfile
            local path_regex = vim.regex("/templates/*\\.(tpl|yaml)$|*.gotmpl|helmfile*.yaml")
            if path_regex and path_regex:match_str(path) then
                return "helm"
            end

            -- return yaml if nothing else
            return "yaml"
        end

        vim.filetype.add({
            extension = {
                yaml = helm_ft,
            },
        })
    end,
    ft = "helm",
}
