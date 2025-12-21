---@class ActionSourceItem
---@field label string
---@field documentation? string
---@field on_confirm fun()
---@field kind? number
---@field filter? fun(before_cursor: string, entire_line: string, context: table): boolean
---@field preselect? number
---@field filterText? string

---@class ActionSourceOpts
---@field items ActionSourceItem[]
---@field priority? number

local M = {}

--- Registers an "action" type source that does not insert text, but executes on_confirm.
---@param name string
---@param filetypes string[]
---@param opts ActionSourceOpts
---@return boolean success
function M.register_action_source(name, filetypes, opts)
    local ok_cmp, cmp = pcall(require, "cmp")
    if not ok_cmp then return false end

    -- Register listener directly, no internal flag
    cmp.event:on("confirm_done", function(event)
        local item = event.entry:get_completion_item()
        if item.data and type(item.data.on_confirm) == "function" then
            item.data.on_confirm()
        end
    end)

    local function make_empty_textedit(params)
        local context = params and params.context or {}
        local line_text = context.cursor_line or ""
        local cursor = context.cursor or {}
        local row = (cursor.row or 1) - 1
        local col = cursor.col or (#line_text + 1)
        return {
            newText = "",
            range = {
                start = { line = row, character = col },
                ["end"] = { line = row, character = col },
            },
        }
    end

    local function has_source(sources, source_name)
        for _, s in ipairs(sources or {}) do
            if s and s.name == source_name then return true end
        end
        return false
    end

    local function add_source_to_filetypes(filetypes_list, source_entry)
        local global_conf = cmp.get_config() or {}
        local global_sources = vim.deepcopy(global_conf.sources) or {}
        if has_source(global_sources, source_entry.name) then return end
        local filetype_sources = cmp.config.sources({ source_entry }, global_sources)
        cmp.setup.filetype(filetypes_list, { sources = filetype_sources })
    end

    local source = {}
    function source:complete(params, callback)
        local context = params.context or {}
        local line = context.cursor_line or ""
        local col = (context.cursor and context.cursor.col) or (#line + 1)
        local before_cursor = line:sub(1, col - 1) or ""

        local items_to_return = {}
        for _, item_config in ipairs(opts.items) do
            if not item_config.filter or item_config.filter(before_cursor, line, context) ~= false then
                table.insert(items_to_return, {
                    label = item_config.label or "",
                    kind = item_config.kind or cmp.lsp.CompletionItemKind.Text,
                    documentation = item_config.documentation or "",
                    textEdit = make_empty_textedit(params),
                    data = { on_confirm = item_config.on_confirm },
                    preselect = item_config.preselect,
                    filterText = item_config.filterText,
                })
            end
        end

        callback({ items = items_to_return })
    end

    cmp.register_source(name, source)
    add_source_to_filetypes(filetypes, { name = name, priority = opts.priority or 9999 })
    return true
end

return M
