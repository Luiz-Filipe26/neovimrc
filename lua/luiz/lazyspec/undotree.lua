return {
    'mbbill/undotree',
    config = function()
        local git_diff_path = "C:/Program Files/Git/usr/bin"

        if vim.fn.has("win32") == 1
            and vim.fn.executable("diff") == 0
            and vim.fn.isdirectory(git_diff_path) == 1
        then
            vim.env.PATH = vim.env.PATH .. ";" .. git_diff_path
        end
    end
}
