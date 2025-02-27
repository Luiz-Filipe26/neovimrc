return {
    { "nvim-treesitter/playground" },
    { "theprimeagen/harpoon" },
    { "tpope/vim-fugitive" },
    {
        "j-hui/fidget.nvim",
        config = true
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
    { "theprimeagen/vim-be-good" },
    { "theprimeagen/refactoring.nvim" },
    { "folke/zen-mode.nvim" },
    { "github/copilot.vim" },
    { "eandrju/cellular-automaton.nvim" },
}
