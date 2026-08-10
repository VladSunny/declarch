-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in    = 4,
        gaps_out   = 8,
        float_gaps = 8,

        border_size = 2,

        col = {
            active_border   = "rgba(B7A7D8ff)",
            inactive_border = "rgba(3B4251cc)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled        = true,
            range          = 12,
            render_power   = 2,
            color          = 0x590c0e12,
            color_inactive = 0x400c0e12,
        },

        blur = {
            enabled   = true,
            size      = 8,
            passes    = 2,
            vibrancy  = 0.05,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Smoky Lofi curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("smokyOut",  { type = "bezier", points = { {0.22, 1}, {0.36, 1} } })
hl.curve("smokyIn",   { type = "bezier", points = { {0.4, 0},  {1, 1}    } })
hl.curve("smokyMove", { type = "bezier", points = { {0.65, 0}, {0.35, 1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 1.4, bezier = "smokyOut" })
hl.animation({ leaf = "border",        enabled = true, speed = 1.4, bezier = "smokyOut" })
hl.animation({ leaf = "windows",       enabled = true, speed = 1.4, bezier = "smokyOut",  style = "slide" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 1.8, bezier = "smokyOut",  style = "slide" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.2, bezier = "smokyIn",   style = "slide" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 1.4, bezier = "smokyOut" })
hl.animation({ leaf = "fade",          enabled = true, speed = 1.4, bezier = "smokyOut" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.8, bezier = "smokyOut" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.2, bezier = "smokyIn" })
hl.animation({ leaf = "layers",        enabled = true, speed = 1.8, bezier = "smokyOut",  style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.2, bezier = "smokyIn",   style = "fade" })
hl.animation({ leaf = "fadeLayers",    enabled = true, speed = 1.8, bezier = "smokyOut" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.2, bezier = "smokyIn" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.6, bezier = "smokyMove", style = "slidefade 20%" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us, ru",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:win_space_toggle",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
