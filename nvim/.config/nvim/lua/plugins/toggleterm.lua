return {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        function _G.set_terminal_keymaps()
            local kopts = { buffer = 0 }
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], kopts)
            vim.keymap.set('t', 'jk', [[<C-\><C-n>]], kopts)
            vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], kopts)
            vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], kopts)
            vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], kopts)
            vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], kopts)
            vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], kopts)
        end

        -- if you only want these mappings for toggle term use term://*toggleterm#* instead
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

        vim.keymap.set('n', '<leader>tt', ':ToggleTerm name=term<cr>',
            { noremap = true, silent = true, desc = "Toggle Terminal" })
    end
}
