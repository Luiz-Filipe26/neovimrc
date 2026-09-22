return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
        require("nvim-treesitter").install({
            "asm",
            "bash",
            "c",
            "cmake",
            "cpp",
            "css",
            "diff",
            "dockerfile",
            "editorconfig",
            "gitattributes",
            "gitignore",
            "html",
            "ini",
            "java",
            "javascript",
            "jsdoc",
            "json",
            "kotlin",
            "lua",
            "markdown",
            "markdown_inline",
            "powershell",
            "properties",
            "python",
            "rust",
            "sql",
            "ssh_config",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("LuizTreesitter", {
                clear = true,
            }),

            callback = function(args)
                local filetype = vim.bo[args.buf].filetype
                local language = vim.treesitter.language.get_lang(filetype)

                if not language then
                    return
                end

                local ok, loaded = pcall(
                    vim.treesitter.language.add,
                    language
                )

                if not ok or not loaded then
                    return
                end

                vim.treesitter.start(args.buf, language)

                if filetype == "markdown" then
                    vim.bo[args.buf].syntax = "ON"
                end
            end,
        })
    end,
}
