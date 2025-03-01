return {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
        return {
            sources = {
                require("null-ls").builtins.formatting.clang_format,
            }
        }
    end
}
