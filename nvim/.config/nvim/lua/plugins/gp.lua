return {
    "robitx/gp.nvim",
    config = function()
        require("gp").setup({
            hooks = {
                Translate = function(gp, params)
                    local template = "Having the following text:\n\n"
                        .. "```text\n{{selection}}\n```\n\n"
                        .. "Please translate this into standard concise American English."
                        .. "\n\nRespond exclusively with the snippet that should replace the selection above."
                    local agent = gp.get_command_agent()
                    gp.info("Translating selection with agent: " .. agent.name)
                    gp.Prompt(params, gp.Target.rewrite, nil, agent.model, template, agent.system_prompt)
                end,
                Correct = function(gp, params)
                    local template = "Having the following text:\n\n"
                        .. "```text\n{{selection}}\n```\n\n"
                        .. "Please rewrite this in standard, concise American English."
                        .. "\n\nRespond exclusively with the snippet that should replace the selection above."
                    local agent = gp.get_command_agent()
                    gp.info("Correcting selection with agent: " .. agent.name)
                    gp.Prompt(params, gp.Target.rewrite, nil, agent.model, template, agent.system_prompt)
                end,
            },
        })
        -- VISUAL mode mappings
        -- s, x, v modes are handled the same way by which_key
        require("which-key").add({
            {
                mode = { "v" },
                { "<leader>c<C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "Visual Chat New tabnew", nowait = true, remap = false },
                { "<leader>c<C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "Visual Chat New vsplit", nowait = true, remap = false },
                { "<leader>c<C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "Visual Chat New split", nowait = true, remap = false },
                { "<leader>ca", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)", nowait = true, remap = false },
                { "<leader>cb", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)", nowait = true, remap = false },
                { "<leader>cc", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New", nowait = true, remap = false },
                { "<leader>cg", group = "generate into new ..", nowait = true, remap = false },
                { "<leader>cge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew", nowait = true, remap = false },
                { "<leader>cgn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew", nowait = true, remap = false },
                { "<leader>cgp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup", nowait = true, remap = false },
                { "<leader>cgt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew", nowait = true, remap = false },
                { "<leader>cgv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew", nowait = true, remap = false },
                { "<leader>ch", group = "hook", nowait = true, remap = false },
                { "<leader>chc", ":<C-u>'<,'>GpCorrect<cr>", desc = "Visual Hook Correct", nowait = true, remap = false },
                { "<leader>cht", ":<C-u>'<,'>GpTranslate<cr>", desc = "Visual Hook Translate", nowait = true, remap = false },
                { "<leader>ci", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection", nowait = true, remap = false },
                { "<leader>cn", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
                { "<leader>cp", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste", nowait = true, remap = false },
                { "<leader>cr", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite", nowait = true, remap = false },
                { "<leader>cs", "<cmd>GpStop<cr>", desc = "GpStop", nowait = true, remap = false },
                { "<leader>ct", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat", nowait = true, remap = false },
                { "<leader>cw", group = "Whisper", nowait = true, remap = false },
                { "<leader>cwa", ":<C-u>'<,'>GpWhisperAppend<cr>", desc = "Whisper Append (after)", nowait = true, remap = false },
                { "<leader>cwb", ":<C-u>'<,'>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)", nowait = true, remap = false },
                { "<leader>cwe", ":<C-u>'<,'>GpWhisperEnew<cr>", desc = "Whisper Enew", nowait = true, remap = false },
                { "<leader>cwn", ":<C-u>'<,'>GpWhisperNew<cr>", desc = "Whisper New", nowait = true, remap = false },
                { "<leader>cwp", ":<C-u>'<,'>GpWhisperPopup<cr>", desc = "Whisper Popup", nowait = true, remap = false },
                { "<leader>cwr", ":<C-u>'<,'>GpWhisperRewrite<cr>", desc = "Whisper Rewrite", nowait = true, remap = false },
                { "<leader>cwt", ":<C-u>'<,'>GpWhisperTabnew<cr>", desc = "Whisper Tabnew", nowait = true, remap = false },
                { "<leader>cwv", ":<C-u>'<,'>GpWhisperVnew<cr>", desc = "Whisper Vnew", nowait = true, remap = false },
                { "<leader>cww", ":<C-u>'<,'>GpWhisper<cr>", desc = "Whisper", nowait = true, remap = false },
                { "<leader>cx", ":<C-u>'<,'>GpContext<cr>", desc = "Visual GpContext", nowait = true, remap = false },
            },
        })

        -- NORMAL mode mappings
        require("which-key").add({
            { "<leader>c<C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew", nowait = true, remap = false },
            { "<leader>c<C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit", nowait = true, remap = false },
            { "<leader>c<C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split", nowait = true, remap = false },
            { "<leader>ca", "<cmd>GpAppend<cr>", desc = "Append (after)", nowait = true, remap = false },
            { "<leader>cb", "<cmd>GpPrepend<cr>", desc = "Prepend (before)", nowait = true, remap = false },
            { "<leader>cc", "<cmd>GpChatNew<cr>", desc = "New Chat", nowait = true, remap = false },
            { "<leader>cf", "<cmd>GpChatFinder<cr>", desc = "Chat Finder", nowait = true, remap = false },
            { "<leader>cg", group = "generate into new ..", nowait = true, remap = false },
            { "<leader>cge", "<cmd>GpEnew<cr>", desc = "GpEnew", nowait = true, remap = false },
            { "<leader>cgn", "<cmd>GpNew<cr>", desc = "GpNew", nowait = true, remap = false },
            { "<leader>cgp", "<cmd>GpPopup<cr>", desc = "Popup", nowait = true, remap = false },
            { "<leader>cgt", "<cmd>GpTabnew<cr>", desc = "GpTabnew", nowait = true, remap = false },
            { "<leader>cgv", "<cmd>GpVnew<cr>", desc = "GpVnew", nowait = true, remap = false },
            { "<leader>cn", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
            { "<leader>cr", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite", nowait = true, remap = false },
            { "<leader>cs", "<cmd>GpStop<cr>", desc = "GpStop", nowait = true, remap = false },
            { "<leader>ct", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat", nowait = true, remap = false },
            { "<leader>cw", group = "Whisper", nowait = true, remap = false },
            { "<leader>cwa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)", nowait = true, remap = false },
            { "<leader>cwb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)", nowait = true, remap = false },
            { "<leader>cwe", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew", nowait = true, remap = false },
            { "<leader>cwn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New", nowait = true, remap = false },
            { "<leader>cwp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup", nowait = true, remap = false },
            { "<leader>cwr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite", nowait = true, remap = false },
            { "<leader>cwt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew", nowait = true, remap = false },
            { "<leader>cwv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew", nowait = true, remap = false },
            { "<leader>cww", "<cmd>GpWhisper<cr>", desc = "Whisper", nowait = true, remap = false },
            { "<leader>cx", "<cmd>GpContext<cr>", desc = "Toggle GpContext", nowait = true, remap = false },
        })

        -- INSERT mode mappings
        require("which-key").add({
            {
                mode = { "i" },
                { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew", nowait = true, remap = false },
                { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit", nowait = true, remap = false },
                { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split", nowait = true, remap = false },
                { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)", nowait = true, remap = false },
                { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)", nowait = true, remap = false },
                { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat", nowait = true, remap = false },
                { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder", nowait = true, remap = false },
                { "<C-g>g", group = "generate into new ..", nowait = true, remap = false },
                { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew", nowait = true, remap = false },
                { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew", nowait = true, remap = false },
                { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup", nowait = true, remap = false },
                { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew", nowait = true, remap = false },
                { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew", nowait = true, remap = false },
                { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
                { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite", nowait = true, remap = false },
                { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop", nowait = true, remap = false },
                { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat", nowait = true, remap = false },
                { "<C-g>w", group = "Whisper", nowait = true, remap = false },
                { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)", nowait = true, remap = false },
                { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)", nowait = true, remap = false },
                { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew", nowait = true, remap = false },
                { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New", nowait = true, remap = false },
                { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup", nowait = true, remap = false },
                { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite", nowait = true, remap = false },
                { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew", nowait = true, remap = false },
                { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew", nowait = true, remap = false },
                { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper", nowait = true, remap = false },
                { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext", nowait = true, remap = false },
            },
        })
    end,
}
