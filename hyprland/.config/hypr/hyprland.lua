local colors = require("confs.colors")
require("confs.variables")
require("confs.animations")
require("confs.autostart")
require("confs.keybinds")
require("confs.monitors")
require("confs.windowrules")

hl.config({
    general = {
        col = {
            active_border   = colors.red,
            inactive_border = colors.black3,
        },
        border_size = 2,
        gaps_in     = 2,
        gaps_out    = 4,
    },

    decoration = {
        rounding         = 4,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.9,

        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 2,
            color        = "rgba(0f0f0f7f)",
        },

        blur = {
            enabled = false,
        },
    },

    dwindle = {
        preserve_split = true,
    },

    input = {
        kb_layout = "pt",
    },
})
