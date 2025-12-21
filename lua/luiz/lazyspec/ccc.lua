return {
    "uga-rosa/ccc.nvim",
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
    config = function()
        require("ccc").setup()

        local action_source = require("luiz.cmp_actions")

        action_source.register_action_source("color_picker_source", { "css", "scss", "html" }, {
            items = {
                {
                    label = " Color Picker",
                    documentation = "Opens ccc.nvim color picker",
                    kind = require("cmp").lsp.CompletionItemKind.Color,
                    filter = function(before_cursor, entire_line, context)
                        local last_word = before_cursor:match("(%S+)%s*$")
                        return last_word == "color:" or last_word == "background-color:"
                    end,
                    on_confirm = function()
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                        vim.cmd("CccPick")
                    end,
                }
            },
            priority = 9999,
        })
    end
}
