return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")

        ts.install({
            "vimdoc", "javascript", "typescript", "c", "lua", "rust",
            "jsdoc", "bash", "cpp",
            "markdown", "markdown_inline"
        })

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                local lang = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
                local installed_parsers = ts.get_installed()
                if vim.tbl_contains(installed_parsers, lang) then
                    vim.treesitter.start()
                end
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function()
                vim.cmd("syntax on")
            end,
        })
    end
}
