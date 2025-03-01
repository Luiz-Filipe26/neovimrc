local map = vim.keymap.set
local function nmap(...) vim.keymap.set("n", ...) end
local function vmap(...) vim.keymap.set("v", ...) end
local function imap(...) vim.keymap.set("i", ...) end
local function xmap(...) vim.keymap.set("x", ...) end
local function nvmap(...) vim.keymap.set({ "n", "v" }, ...) end

vim.g.mapleader = " "
--nmap("<leader>pv", vim.cmd.Ex)

vmap("J", ":m '>+1<CR>gv=gv")
vmap("K", ":m '<-2<CR>gv=gv")

nmap("J", "mzJ`z")
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- greatest remap ever
xmap("<leader>p", [["_dP]])

-- my personal remap
nmap("<leader><leader>p", [["+p]])

-- next greatest remap ever : asbjornHaland
nvmap("<leader>y", [["+y]])
nmap("<leader>Y", [["+Y]])

nvmap("<leader>d", [["_d]])

imap("<C-c>", "<Esc>")

nmap("Q", "<nop>")
nmap("<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

nmap("<C-k>", "<cmd>cnext<CR>zz")
nmap("<C-j>", "<cmd>cprev<CR>zz")
nmap("<leader>k", "<cmd>lnext<CR>zz")
nmap("<leader>j", "<cmd>lprev<CR>zz")

nmap("<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
nmap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

nvmap("<leader>ew", ":lua require('luiz.cpp_build').Compile_all_cpp_files()<CR>", { noremap = true, silent = true })
nvmap("<leader>ee", ":lua require('luiz.cpp_build').Compile_current_file()<CR>", { noremap = true, silent = true })
nvmap("<leader>er", ":lua require('luiz.cpp_build').Run_current_file()<CR>", { noremap = true, silent = true })



local function remap_plugin(name, on_loaded)
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
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
        local builtin = require("telescope.builtin")

        nmap("<leader>pf", builtin.find_files, {})
        nmap("<leader>pg", builtin.git_files, {})
        nmap("<leader>ps", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
    end,
    ["vim-fugitive"] = function()
        nmap("<leader>gs", vim.cmd.Git)
        nmap("<leader>gp", vim.cmd.GitPush)
        nmap("<leader>gP", vim.cmd.GitPullRebase)
        nmap("<leader>gt", vim.cmd.GitPushOrigin)
    end,
    ["harpoon"] = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        nmap("<leader>hx", mark.add_file)
        nmap("<leader>hn", ui.nav_next)
        nmap("<leader>hp", ui.nav_prev)
        nmap("<leader>hm", ui.toggle_quick_menu)
    end,
    ["lsp-zero.nvim"] = function()
        nmap("<leader>f", vim.lsp.buf.format)
        nmap("gD", vim.lsp.buf.declaration)
        nmap("gd", vim.lsp.buf.definition)
        nmap("K", vim.lsp.buf.hover)
        nmap("gi", vim.lsp.buf.implementation)
        nmap("<C-k>", vim.lsp.buf.signature_help)
        nmap("<space>wa", vim.lsp.buf.add_workspace_folder)
        nmap("<space>wr", vim.lsp.buf.remove_workspace_folder)
        nmap("<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end)
        nmap("<space>D", vim.lsp.buf.type_definition)
        nmap("<space>rn", vim.lsp.buf.rename)
        nvmap("<space>ca", vim.lsp.buf.code_action)
        nmap("gr", vim.lsp.buf.references)
        nmap("<leader>cd", vim.diagnostic.open_float)
        nmap("<space>f", function()
            vim.lsp.buf.format { async = true }
        end)
    end,
    ["undotree"] = function()
        nmap("<leader>u", vim.cmd.UndotreeToggle)
    end,
    ["neogen"] = function()
        local neogen = require("neogen")
        nmap("<leader>nf", function()
            neogen.generate({ type = "func" })
        end)

        nmap("<leader>nt", function()
            neogen.generate({ type = "type" })
        end)
    end,
    ["trouble.nvim"] = function()
        local trouble = require("trouble")
        nmap("<leader>tt", function()
            vim.cmd("Trouble diagnostics toggle")
        end)

        nmap("<C-]>", function()
            trouble.next({ skip_groups = true, jump = true })
        end)

        nmap("<C-[>", function()
            trouble.prev({ skip_groups = true, jump = true })
        end)
    end,
    ["nvim-tree.lua"] = function()
        nmap("<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
        nmap("<C-f>", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })
    end,
    ["nvim-dap"] = function()
        nmap("<leader>db", "<cmd> DapToggleBreakpoint <CR>")
        nmap("<leader>dr", "<cmd> DapContinue <CR>")
    end,
    ["cmake-tools.nvim"] = function ()
        nmap("<leader>mg", ":CMakeGenerate<CR>", { noremap = true, silent = true })
        nmap("<leader>mb", ":CMakeBuild<CR>", { noremap = true, silent = true })
        nmap("<leader>mr", ":CMakeRun<CR>", { noremap = true, silent = true })
        nmap("<leader>md", ":CMakeDebug<CR>", { noremap = true, silent = true })
    end
}

execute_all_remaps(plugin_remaps)

return {
    cmp_remaps = function()
        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        return {
            ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
            ["<C-y>"] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
        }
    end,
}
