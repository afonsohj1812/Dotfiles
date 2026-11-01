local laptop = "eDP-1"
local external = "HDMI-A-1"

hl.monitor({ output = laptop,   mode = "1920x1080@144", position = "auto", scale = 1 })
hl.monitor({ output = external, mode = "1920x1080@60",  position = "auto", scale = 1 })

hl.workspace_rule({ workspace = "1", monitor = laptop, default = true })
hl.workspace_rule({ workspace = "2", monitor = laptop })
hl.workspace_rule({ workspace = "3", monitor = external, default = true })
hl.workspace_rule({ workspace = "4", monitor = external })
