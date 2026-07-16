-----------------------
-------- RULES --------
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
hl.window_rule({
    name = "vscode",
    match = {
        class = "code"
    },
    opacity = "0.98 0.95 1.0"
})

hl.window_rule ({
    name = "nemo",
    match = {
        class = "nemo"
    },
    opacity = "0.9 0.85 1.0",
    float = true,
    size = "907 525"
})

hl.window_rule ({
    name = "telegram",
    match = {
        class = "org.telegram.desktop"
    },
    opacity = "0.9 0.85 1.0"
})

hl.window_rule ({
    name = "terminal",
    match = {
        class = "kitty"
    },
    opacity = "0.9 0.85 1.0",
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