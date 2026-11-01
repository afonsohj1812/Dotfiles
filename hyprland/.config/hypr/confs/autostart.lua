local vars = require("confs.variables")

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper & hyprlock & hypridle & mako & clipse -listen")
    hl.exec_cmd(vars.social)
    hl.exec_cmd("$HOME/.config/hypr/scripts/battery.sh")
end)
