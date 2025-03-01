return {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function ()
        require("cmake-tools").setup {
            cmake_virtual_text_support = false, -- Show the target related to current file using virtual text (at right corner)
        }
    end
}
