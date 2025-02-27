return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local status_ok, npairs = pcall(require, "nvim-autopairs")
        if not status_ok then
            return
        end

        npairs.setup {
            check_ts = true,
            ts_config = {
                lua = { "string", "source" },
                javascript = { "string", "template_string" },
                java = false,
            },
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
            fast_wrap = {
                map = '<M-e>',
                chars = { '{', '[', '(', '"', "'" },
                pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                offset = 0,
                check_comma = true,
                end_key = '$',
                before_key = 'h',
                after_key = 'l',
                cursor_pos_before = true,
                keys = 'qwertyuiopzxcvbnmasdfghjkl',
                manual_position = true,
                highlight = 'Search',
                highlight_grey = 'Comment'
            },
        }
    end
}
