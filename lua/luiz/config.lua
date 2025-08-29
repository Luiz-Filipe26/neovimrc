local augroup = vim.api.nvim_create_augroup

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.hl.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

vim.api.nvim_create_user_command("Trim", function()
    vim.cmd([[%s/\s\+$//e]])
end, {})


local providers_to_disable = { "perl", "ruby" }
for _, provider_name in ipairs(providers_to_disable) do
    vim.g["loaded_" .. provider_name .. "_provider"] = 0
end


--[[
function _G.custom_cpp_indent()
    local ok, result = pcall(vim.fn.eval, _G.original_indentexpr)
    if not ok or type(result) ~= "number" then
        vim.notify("Indentexpr inválido ou nil", vim.log.levels.WARN)
        return 0
    end

    local ts_utils = require("nvim-treesitter.ts_utils")
    local row = vim.v.lnum - 1
    local node = ts_utils.get_node_at_cursor(0, row, 0)

    if node and node:type() == "access_specifier" then
        vim.notify("Access specifier detectado na linha " .. vim.v.lnum, vim.log.levels.INFO)
        return vim.fn.indent(vim.v.lnum)
    end

    vim.notify("Usando indentexpr original: " .. result, vim.log.levels.INFO)
    return result
end

autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        print("oi!")
        _G.original_indentexpr = vim.bo.indentexpr
        vim.bo.indentexpr = 'v:lua.custom_cpp_indent()'
    end,
})

]]
