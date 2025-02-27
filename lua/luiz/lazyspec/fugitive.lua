return { "tpope/vim-fugitive", config = function()

    -- Define the user commands for fugitive
    vim.api.nvim_create_user_command('GitPush', function()
        if vim.bo.ft == "fugitive" then
            vim.cmd.Git('push')
        end
    end, {})

    -- rebase always
    vim.api.nvim_create_user_command('GitPullRebase', function()
        if vim.bo.ft == "fugitive" then
            vim.cmd.Git({'pull', '--rebase'})
        end
    end, {})

    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
    -- needed if i did not set the branch up correctly
    vim.api.nvim_create_user_command('GitPushOrigin', function()
        local branch = vim.fn.input("Branch: ")
        if vim.bo.ft == "fugitive" then
            vim.cmd('Git push -u origin ' .. branch)
        end
    end, {})
end,
}
