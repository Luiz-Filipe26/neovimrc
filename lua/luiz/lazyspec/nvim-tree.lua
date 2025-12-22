return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    opts = {
        filters = { dotfiles = false },
        git = { enable = true, ignore = false },

        disable_netrw = true,
        hijack_cursor = true,
        sync_root_with_cwd = true,
        update_focused_file = { enable = true, update_root = true },

        view = {
            width = 30,
            preserve_window_proportions = true,
            side = "left",
        },

        renderer = {
            root_folder_label = false,
            highlight_git = true,

            indent_markers = { enable = true },

            icons = {
                show = {
                    file = false,
                    folder = false,
                    folder_arrow = true,
                    git = false,
                    modified = false,
                },

                glyphs = {
                    default = "",
                    symlink = "",
                    bookmark = "Bm",
                    modified = "*",
                    folder = {
                        arrow_closed = ">",
                        arrow_open = "v",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "[M]",
                        staged = "[S]",
                        unmerged = "[U]",
                        renamed = "[R]",
                        untracked = "[?]",
                        deleted = "[D]",
                        ignored = "[!]",
                    },
                },
            },
        },
    }
}
