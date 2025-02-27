vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- my personal remap
vim.keymap.set("n", "<leader><leader>p", [["+p]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.api.nvim_set_keymap('', '<leader>ew', ':lua require("cpp_build").Compile_all_cpp_files()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<leader>ee', ':lua require("cpp_build").Compile_current_file()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<leader>er', ':lua require("cpp_build").Run_current_file()<CR>', { noremap = true, silent = true })



local function remap_plugin(name, on_loaded)
    vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyLoad',
        callback = function(args)
            if args.data == name then
                on_loaded()
            end
        end,
    })
end

local function execute_all_remaps(plugin_remaps)
    for plugin_name, remap_func in pairs(plugin_remaps) do
        remap_plugin(plugin_name, remap_func)
    end
end

local plugin_remaps = {
    ["telescope.nvim"] = function()
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-g>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
    end,
    ["vim-fugitive"] = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        vim.keymap.set("n", "<leader>p", vim.cmd.GitPush)
        vim.keymap.set("n", "<leader>P", vim.cmd.GitPullRebase)
        vim.keymap.set("n", "<leader>t", vim.cmd.GitPushOrigin)
    end,
    ["harpoon"] = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set('n', '<leader>x', mark.add_file)
        vim.keymap.set('n', '<leader>n', ui.nav_next)
        vim.keymap.set('n', '<leader>b', ui.nav_prev)
        vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu)
    end,
    ["lsp-zero.nvim"] = function()
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end)
    end,
    ["undotree"] = function ()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
    ["neogen"] = function()
        local neogen = require('neogen')
        vim.keymap.set("n", "<leader>nf", function()
            neogen.generate({ type = "func" })
        end)

        vim.keymap.set("n", "<leader>nt", function()
            neogen.generate({ type = "type" })
        end)
    end,
    ["trouble.nvim"] = function()
        local trouble = require("trouble")
        vim.keymap.set("n", "<leader>tt", function()
            trouble.toggle()
        end)

        vim.keymap.set("n", "[t", function()
            trouble.next({skip_groups = true, jump = true});
        end)

        vim.keymap.set("n", "]t", function()
            trouble.previous({skip_groups = true, jump = true});
        end)
    end
}


execute_all_remaps(plugin_remaps)

return {
    cmp_remaps = function()
        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        return {
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
        }
    end

}
