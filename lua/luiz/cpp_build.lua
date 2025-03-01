local M = {}

function M.Compile_current_file()
    local current_file_with_dir = vim.fn.expand("%:p")
    local current_file = vim.fn.expand("%:t:r")

    if not string.find(current_file_with_dir, "%.cpp$") then
        print("Erro: Este não é um arquivo C++ (.cpp)")
        return
    end

    local output_file = (vim.loop.os_uname().sysname == "Linux") and current_file or (current_file .. ".exe")
    vim.cmd("! clang++ \"" .. current_file_with_dir .. "\" -o " .. output_file)
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

    local clang_cmd = "clang++ -o " .. output_file
    for _, file in ipairs(files) do
        clang_cmd = clang_cmd .. " '" .. file .. "'"
    end

    vim.cmd("! " .. clang_cmd)
end

function M.Run_current_file()
    local file_name = vim.fn.expand("%:t:r")
    local parent_dir = vim.fn.expand("%:p:r")

    if vim.loop.os_uname().sysname ~= "Linux" then
        file_name = file_name .. ".exe"
    end
    local file_path = parent_dir .. file_name

    if vim.fn.filereadable(file_path) ~= 1 then
        parent_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
        file_path = parent_dir .. file_name
    end

    if vim.fn.filereadable(file_path) ~= 1 then
        print("Erro: Arquivo '" .. file_path .. "' não encontrado.")
        return
    end

    local cmd = "echo 'Executando: " .. file_path .. "'; " .. file_path

    vim.cmd(":split | :startinsert | :terminal " .. cmd)
end

return M
