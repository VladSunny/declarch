-----------------------
-------- RULES --------
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
hl.window_rule({
    name = "vscode",
    match = {
        class = "code",
    },
})

hl.window_rule ({
    name = "nemo",
    match = {
        class = "nemo"
    },
    float = true,
    size = "907 525"
})

hl.window_rule ({
    name = 'yazi',
    match = {
        class = "yazi_float"
    },
    float = true,
    size = "907 525"
})

hl.window_rule ({
    name = "telegram",
    match = {
        class = "org.telegram.desktop",
    },
})

hl.window_rule ({
    name = "terminal",
    match = {
        class = "kitty"
    },
    float = true,
    size = "866 491"
})



local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.layer_rule({
    name = "dunst",
    match = {
        namespace = "^notifications$",
    },
    blur = true,
    ignore_alpha = 0.2,
    animation = "fade",
})
