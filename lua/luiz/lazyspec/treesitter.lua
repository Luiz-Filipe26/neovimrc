local thin = vim.env.NVIM_THIN == "1"

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = thin and function()
        local task = require("nvim-treesitter").update(nil, { max_jobs = 1 })
        assert(task:wait(600000), "Tree-sitter parser update failed")
    end or ":TSUpdate",

    config = function()
        if thin then
            -- Automatic installs and TSInstall/TSUpdate share this module.
            local installer = require("nvim-treesitter.install")
            for _, operation in ipairs({ "install", "update" }) do
                local run = installer[operation]
                installer[operation] = function(languages, options)
                    options = vim.tbl_extend("force", options or {}, { max_jobs = 1 })
                    return run(languages, options)
                end
            end
        end

        local task = require("nvim-treesitter").install({
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
        if thin then
            assert(task:wait(600000), "Tree-sitter parser installation failed")
        end

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
