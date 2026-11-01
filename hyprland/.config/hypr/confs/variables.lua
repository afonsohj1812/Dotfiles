hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("QT_QPA_PLATFORMTHEME", "kde")

return {
    terminal    = "kitty",
    fileManager = "dolphin",
    browser     = "google-chrome-stable --disable-features=WaylandWpColorManagerV1",
    editor      = "code",
    social      = "discord",
    musicPlayer = "env LD_PRELOAD=/usr/lib/spotify-adblock.so spotify",
    gameEngine  = "godot",
    pixelEditor = "libresprite",
}
