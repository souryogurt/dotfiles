return {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
        autochdir = true,
        insert_mappings = false,
        shade_terminals = false
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        function _G.set_terminal_keymaps()
            local kopts = { buffer = 0 }
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], kopts)
            vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], kopts)
        end

        -- if you only want these mappings for toggle term use term://*toggleterm#* instead
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

        vim.keymap.set('n', '<leader>tt', ':ToggleTerm name=term<cr>',
            { noremap = true, silent = true, desc = "Toggle Terminal" })
    end
}
