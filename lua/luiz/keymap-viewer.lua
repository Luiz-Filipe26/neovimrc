local M = {}
local bit = require("bit")

local mode_bit_to_string = {
    [0x01] = "n",
    [0x02] = "v",
    [0x04] = "x",
    [0x08] = "s",
    [0x10] = "i",
    [0x20] = "c",
    [0x40] = "o",
    [0x80] = "!"
}

local ordered_mode_bits = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 }

local function convert_mode_bits_to_string(bits)
    local concatenated_modes = ""
    for _, bitmask in ipairs(ordered_mode_bits) do
        if bit.band(bits, bitmask) ~= 0 then
            concatenated_modes = concatenated_modes .. mode_bit_to_string[bitmask]
        end
    end
    return concatenated_modes
end

local function detect_source(sid, script_path, plugin_paths)
    if sid and sid < 0 then
        return "Builtin"
    elseif type(script_path) ~= "string" or script_path == "" then
        return "Other"
    elseif script_path:match(vim.fn.stdpath("config")) then
        return "User"
    end
    for _, path in ipairs(plugin_paths) do
        if script_path:match(path) then
            return "Plugin"
        end
    end
    return "Other"
end

local function build_sid_table()
    local sid_table = {}
    for _, script_info in ipairs(vim.fn.getscriptinfo()) do
        if script_info.sid and type(script_info.name) == "string" then
            sid_table[script_info.sid] = script_info.name
        end
    end
    return sid_table
end

local function parse_maplist_set(maplist, sid_to_script_path, plugin_paths)
    local keymap_set = {}
    for _, keymap in ipairs(maplist) do
        local modes_string = convert_mode_bits_to_string(keymap.mode_bits)
        local script_path = keymap.sid and (sid_to_script_path[keymap.sid] or "") or ""
        local origin = detect_source(keymap.sid, script_path, plugin_paths)
        local unique_key = origin .. "|" .. keymap.lhs
        modes_string = ((keymap_set[unique_key] and keymap_set[unique_key].modes) or "") .. modes_string
        keymap_set[unique_key] = {
            lhs = keymap.lhs,
            rhs = keymap.rhs or "",
            origin = origin,
            modes = modes_string,
            script_path = script_path,
        }
    end
    return keymap_set
end

local function set_to_array(set_table)
    local array = {}
    for _, value in pairs(set_table) do
        table.insert(array, value)
    end
    return array
end

local function merge_opts(defaults, opts)
    opts = opts or {}
    for key, value in pairs(defaults) do
        if opts[key] == nil then opts[key] = value end
    end
    return opts
end

local function build_display_items(keymap_array, opts)
    local items = {}
    for _, keymap in ipairs(keymap_array) do
        local include = true
        include = include and (not opts.filter_origins or vim.tbl_contains(opts.filter_origins, keymap.origin))
        include = include and (not opts.filter_modes or keymap.modes:match("[" .. opts.filter_modes .. "]"))
        include = include and (not opts.filter_lhs_pattern or keymap.lhs:match(opts.filter_lhs_pattern))
        include = include and (opts.show_empty_rhs or keymap.rhs ~= "")
        if include then
            local origin_part = opts.show_origins and keymap.origin or ""
            table.insert(items, {
                text = string.format(
                    opts.display_format,
                    keymap.modes,
                    keymap.lhs,
                    type(keymap.rhs) == "function" and "<Lua function>" or keymap.rhs,
                    origin_part
                ),
                script_path = keymap.script_path
            })
        end
    end
    return items
end

local function prepare_keymaps(opts)
    local sid_table = build_sid_table()
    local keymap_set = parse_maplist_set(vim.fn.maplist(), sid_table, opts.plugin_paths)
    local keymap_array = set_to_array(keymap_set)
    table.sort(keymap_array, function(a, b)
        local pa = opts.origin_priority[a.origin] or 99
        local pb = opts.origin_priority[b.origin] or 99
        return pa < pb
    end)
    return build_display_items(keymap_array, opts)
end

local function make_finder(display_items)
    local finders = require("telescope.finders")
    return finders.new_table {
        results = display_items,
        entry_maker = function(entry)
            return {
                value = entry,
                display = entry.text,
                ordinal = entry.text,
                script_path = entry.script_path
            }
        end
    }
end

local function make_attach_mappings()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    return function(prompt_bufnr, map)
        map("i", "<CR>", function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if selection.script_path and selection.script_path ~= "" then
                vim.cmd("edit " .. selection.script_path)
            end
        end)
        return true
    end
end

local function show_keymaps(opts)
    local display_items = prepare_keymaps(opts)
    local pickers = require("telescope.pickers")
    local sorters = require("telescope.config").values.generic_sorter
    pickers.new({}, {
        prompt_title = opts.prompt_title,
        finder = make_finder(display_items),
        sorter = sorters({}),
        attach_mappings = make_attach_mappings(),
    }):find()
end

local function create_lazyload_autocmd(plugin_name, keymap)
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(args)
            if args.data == plugin_name then
                vim.keymap.set(keymap.modes, keymap.lhs, keymap.rhs, keymap.opts)
            end
        end
    })
end

function M.add_user_keymaps(keymaps)
    for _, keymap in ipairs(keymaps) do
        if keymap.plugin and keymap.plugin ~= "" then
            create_lazyload_autocmd(keymap.plugin, keymap)
        else
            vim.keymap.set(keymap.modes, keymap.lhs, keymap.rhs, keymap.opts)
        end
    end
end

local default_opts = {
    origin_priority = { User = 1, Plugin = 2, Builtin = 3, Other = 4 },
    filter_origins = nil,
    filter_modes = nil,
    filter_lhs_pattern = nil,
    display_format = "%-4s | %-15s | %-40s | %s",
    prompt_title = "Keymaps",
    show_empty_rhs = true,
    show_origins = true,
    plugin_paths = { "/lazy/", "/pack/" },
    user_keymaps = {},
}

M.setup = function(opts)
    local merged_opts = merge_opts(default_opts, opts)
    if merged_opts.user_keymaps and #merged_opts.user_keymaps > 0 then
        M.add_user_keymaps(merged_opts.user_keymaps)
    end
    vim.api.nvim_create_user_command("KeymapViewer", function()
        show_keymaps(merged_opts)
    end, {})
end

return M
