return {
    {
        'williamboman/mason.nvim',
        opts = {
            ensure_installed = {
                "clang-format",
                "codelldb",
            }
        },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "vtsls",
                    "jdtls",
                    "clangd",
                },
            })
        end
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "java-debug-adapter",
                    "java-test",
                },
            })
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
