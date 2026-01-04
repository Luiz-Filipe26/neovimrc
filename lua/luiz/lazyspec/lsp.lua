return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'L3MON4D3/LuaSnip' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        { 'yioneko/nvim-vtsls' },
    },

    config = function()
        local lsp_zero = require('lsp-zero')
        lsp_zero.preset("recommended")

        require('mason-lspconfig').setup({
            ensure_installed = {},
            handlers = nil,
        })

        local capabilities = lsp_zero.get_capabilities()

        local function enable(name, opts)
            opts = opts or {}
            opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, capabilities)
            vim.lsp.config(name, opts)
            vim.lsp.enable(name)
        end

        enable("lua_ls", {
            settings = {
                Lua = { diagnostics = { globals = { "vim", "it", "describe" } } }
            }
        })
        enable("clangd")
        enable("vtsls", {
            settings = {
                vtsls = {
                    enableMoveToFileCodeAction = true,
                    autoUseWorkspaceTsdk = true,
                    experimental = { completion = { enableServerSideFuzzyMatch = true } },
                },
                typescript = {
                    updateImportsOnFileMove = "always",
                    suggest = { completeFunctionCalls = true },
                    tsserver = {
                        maxTsServerMemory = 8192,
                        experimental = { enableProjectDiagnostics = true },
                    },
                },
            },
        })
        local cmp = require('cmp')
        cmp.setup({
            snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
            mapping = cmp.mapping.preset.insert(require('luiz.remap').cmp_remaps()),
            sources = cmp.config.sources(
                { { name = 'nvim_lsp' }, { name = 'luasnip' }, { name = 'nvim_lsp_signature_help' } },
                { { name = 'buffer' } }),
        })

        vim.diagnostic.config({
            float = { focusable = false, style = "minimal", border = "rounded", source = "always", header = "", prefix = "" },
        })
    end,
}
