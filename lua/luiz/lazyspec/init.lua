return {
    { "theprimeagen/harpoon" },
    {
        "j-hui/fidget.nvim",
        config = true
    },
    {
        "axkirillov/unified.nvim",
        lazy = false,
        cmd = "Unified",
        opts = {
            file_tree = {
                enabled = false,
            },
        },
    },
    { "neovim/nvim-lspconfig" },
    { "folke/tokyonight.nvim" },
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                icons = false,
            }
        end
    },
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end
    },
    {
        'barrett-ruth/live-server.nvim',
        build = 'npm install -g live-server',
        cmd = { 'LiveServerStart', 'LiveServerStop' },
        config = true
    },
    { "theprimeagen/vim-be-good" },
    { "theprimeagen/refactoring.nvim" },
    { "folke/zen-mode.nvim" },
    --{ "github/copilot.vim" },
    { "eandrju/cellular-automaton.nvim" },
}
