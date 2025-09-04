return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'L3MON4D3/LuaSnip' },
        { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    },

    config = function()
        -- Setup completion (nvim-cmp)
        local cmp = require('cmp')
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert(require('luiz.remap').cmp_remaps()),
            sources = cmp.config.sources(
                {
                    { name = 'luasnip' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' }
                },
                {
                    { name = 'buffer' },
                }
            ),
        })

        -- Configure diagnostics
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end

}
