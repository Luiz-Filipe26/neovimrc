local M = {}

function M.Compile_current_file()
    local current_file_with_dir = vim.fn.expand("%:p")
    local current_file = vim.fn.expand("%:t:r")

    if not string.find(current_file_with_dir, "%.cpp$") then
        print("Erro: Este não é um arquivo C++ (.cpp)")
        return
    end

    local output_file = (vim.loop.os_uname().sysname == "Linux") and current_file or (current_file .. ".exe")
    vim.cmd("! g++ \"" .. current_file_with_dir .. "\" -o " .. output_file)
end

function M.Compile_all_cpp_files()
    local find_cmd = "find . -type f -name '*.cpp' -print"
    local files = vim.fn.systemlist(find_cmd)

    local parent_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

    local output_file
    if #files == 1 then
        output_file = vim.fn.fnamemodify(files[1], ":r")
    else
        output_file = parent_dir
    end

    output_file = (vim.loop.os_uname().sysname == "Linux") and output_file or (output_file .. ".exe")

    local gpp_cmd = "g++ -o " .. output_file
    for _, file in ipairs(files) do
        gpp_cmd = gpp_cmd .. " '" .. file .. "'"
    end

    vim.cmd("! " .. gpp_cmd)
end

function M.Run_current_file()
    local current_file_path = vim.fn.expand("%:p:r")
    local current_file = (vim.loop.os_uname().sysname == "Linux") and current_file_path or (current_file_path .. ".exe")
    local parent_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")

    print("Tentando executar: " .. current_file)
    print("Parent dir: " .. parent_dir)

    if vim.fn.filereadable(current_file) == 1 then
        vim.cmd(":split | :startinsert | :terminal \"" .. current_file .. "\"")
    elseif vim.fn.filereadable(parent_dir .. "/" .. vim.fn.expand("%:t:r")) == 1 then
        vim.cmd(":split | :startinsert | :terminal \"" .. parent_dir .. "/" .. vim.fn.expand("%:t:r") .. "\"")
    else
        print("Erro: Arquivo executável não encontrado.")
    end
end

return M
