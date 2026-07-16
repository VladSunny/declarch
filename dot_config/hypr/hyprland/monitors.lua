------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output   = "DP-3",
    mode     = "preferred",
    position = "3120x0",
    scale    = 1,
})
hl.monitor({
    output   = "DP-2",
    mode     = "preferred",
    position = "1200x0",
    scale    = 1
})
hl.monitor({
    output    = "DP-1",
    mode      = "preferred",
    position  = "0x-310",
    scale     = 1,
    transform = 1
})

hl.workspace_rule({
    workspace = "2",
    monitor   = "DP-2"
})

hl.workspace_rule({
    workspace = "1",
    monitor   = "DP-1"
})

hl.workspace_rule({
    workspace = "3",
    monitor   = "DP-3"
})