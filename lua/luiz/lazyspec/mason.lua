return {
    {
        'williamboman/mason.nvim',
        opts = {},
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
        config = function()
            local tools = {
                "lua_ls",
                "cssls",
                "jsonls",
                "rust_analyzer",
                "vtsls",
                "jdtls",
                "clangd",
                "codelldb",
                "java-debug-adapter",
                "java-test",
            }

            if vim.fn.executable("clang-format") == 0 then
                if vim.fn.executable("python") == 1 or vim.fn.executable("python3") == 1 then
                    table.insert(tools, "clang-format")
                end
            end

            require("mason-tool-installer").setup({
                ensure_installed = tools,
            })
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require("mason-lspconfig").setup()
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            handlers = {}
        },
    }
}
