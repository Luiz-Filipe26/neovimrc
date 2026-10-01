return {
    {
        'williamboman/mason.nvim',
        cond = vim.env.NVIM_THIN ~= "1",
        opts = {},
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        cond = vim.env.NVIM_THIN ~= "1",
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
        cond = vim.env.NVIM_THIN ~= "1",
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require("mason-lspconfig").setup({
                automatic_enable = false,
            })
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        cond = vim.env.NVIM_THIN ~= "1",
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
