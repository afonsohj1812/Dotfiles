local vars = require("confs.variables")

local mainMod = "SUPER"
local scripts = "/home/afonso/Dotfiles/hyprland/.config/hypr/scripts"
local multimedia = { locked = true, repeating = true }

hl.bind(mainMod .. " + BACKSPACE", hl.dsp.window.close())
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("pkill wlogout || wlogout"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(vars.terminal))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(vars.fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(vars.browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(vars.editor))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(vars.social))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(vars.musicPlayer))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(vars.gameEngine))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(vars.pixelEditor))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + H", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty --class btop btop"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd('kitty --class nmtui env NEWT_COLORS="root=white,default border=red,default window=default,default shadow=default,default title=white,red button=white,red actbutton=white,red compactbutton=white,default checkbox=white,default actcheckbox=white,red entry=white,default disentry=white,default label=white,default listbox=white,default actlistbox=red,default sellistbox=white,default actsellistbox=white,red textbox=white,default acttextbox=white,red emptyscale=,default fullscale=,default helpline=white,default roottext=white,default" nmtui'))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("kitty --class clipse clipse"))
hl.bind(mainMod .. " + J", hl.dsp.exec_cmd(scripts .. "/work.sh"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m output -o ~/Downloads"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m window -o ~/Downloads"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region -o ~/Downloads"))

hl.bind(mainMod .. " + KP_Begin", hl.dsp.exec_cmd("playerctl -p spotify play-pause"))
hl.bind(mainMod .. " + KP_Right", hl.dsp.exec_cmd("playerctl -p spotify next"))
hl.bind(mainMod .. " + KP_Left", hl.dsp.exec_cmd("playerctl -p spotify previous"))
hl.bind(mainMod .. " + KP_Up", hl.dsp.exec_cmd("playerctl -p spotify volume 0.25+"))
hl.bind(mainMod .. " + KP_Down", hl.dsp.exec_cmd("playerctl -p spotify volume 0.25-"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 50%+"), multimedia)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%-"), multimedia)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), multimedia)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), multimedia)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 50%+"), multimedia)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 50%-"), multimedia)
hl.bind("XF86Calculator", hl.dsp.exec_cmd("kcalc"), multimedia)

for i = 1, 6 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.exec_cmd(scripts .. "/move-workspace.sh " .. i))
end
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
