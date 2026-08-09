# Configuration Documentation Reference

This page is the starting point for documentation used while maintaining this dotfiles repository. Prefer the official upstream documentation linked below. Check the installed application version before relying on version-sensitive syntax, and do not copy configuration examples without adapting them to the existing repository structure.

Last reviewed: 2026-08-09.

## chezmoi

chezmoi manages the desired state of files deployed from this source tree into the home directory. Use its naming conventions, templates, attributes, and lifecycle commands instead of editing generated target files directly.

- [Documentation home](https://www.chezmoi.io/) — entry point and project overview.
- [Quick start](https://www.chezmoi.io/quick-start/) — core source-state and target-state workflow.
- [User guide](https://www.chezmoi.io/user-guide/) — practical workflows, machine-specific configuration, secrets, and troubleshooting.
- [Reference](https://www.chezmoi.io/reference/) — complete syntax and behavior reference.
- [Commands](https://www.chezmoi.io/reference/commands/) — command-line reference for `diff`, `apply`, `doctor`, and other operations.
- [Source-state attributes](https://www.chezmoi.io/reference/source-state-attributes/) — meaning of filename prefixes such as `dot_`, `private_`, and `executable_`.
- [Templating guide](https://www.chezmoi.io/user-guide/templating/) — Go templates, variables, and conditional configuration.
- [Upstream repository](https://github.com/twpayne/chezmoi) and [releases](https://github.com/twpayne/chezmoi/releases) — source, changelog, issues, and version history.

Use `chezmoi diff` and `chezmoi apply --dry-run --verbose` before applying changes. Remember that `chezmoi apply` can execute managed scripts.

## metapac

metapac declaratively manages packages from multiple backends. In this repository, package groups live in `dot_config/metapac/groups/*.toml`, while backend configuration lives in `dot_config/metapac/config.toml`.

- [Current documentation](https://docs.rs/metapac/latest/metapac/) — usage, commands, backend behavior, configuration, and group-file syntax.
- [Upstream repository](https://github.com/ripytide/metapac) — canonical README, source, examples, and issue tracker.
- [Release notes](https://github.com/ripytide/metapac/releases) — breaking changes and migration information.
- [Crate metadata](https://crates.io/crates/metapac) — published versions and dependency metadata.

Add packages to the smallest relevant group and keep entries alphabetized where practical. Run `metapac sync` only after reviewing the group and backend configuration. Treat `metapac clean` as potentially destructive: inspect its proposed removals carefully before confirming.

## Hyprland

Hyprland is the Wayland compositor. This repository uses the current Lua configuration API, loaded from `dot_config/hypr/hyprland.lua` and split into focused modules under `dot_config/hypr/hyprland/`.

- [Official wiki](https://wiki.hypr.land/) — canonical documentation entry point.
- [Configuration start page](https://wiki.hypr.land/Configuring/Start/) — Lua configuration structure, loading, reloading, and error behavior.
- [Configuration index](https://wiki.hypr.land/Configuring/) — complete configuration topic index.
- [Variables](https://wiki.hypr.land/Configuring/Basics/Variables/) — `hl.config()` categories, options, and types.
- [Monitors](https://wiki.hypr.land/Configuring/Basics/Monitors/) — output modes, positions, scaling, and monitor rules.
- [Binds](https://wiki.hypr.land/Configuring/Basics/Binds/) — `hl.bind()`, dispatchers, flags, and input switches.
- [Window rules](https://wiki.hypr.land/Configuring/Basics/Window-Rules/) and [workspace rules](https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/) — matching and scoped behavior.
- [Animations](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/) — curves and animation configuration.
- [Using hyprctl](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Using-hyprctl/) — runtime inspection, dispatching, and reload commands.
- [Upstream repository](https://github.com/hyprwm/Hyprland) and [releases](https://github.com/hyprwm/Hyprland/releases) — source and version-specific changes.

The current wiki documents Lua. Avoid old `hyprland.conf` or Hyprlang examples unless intentionally working with Hyprland 0.54 or earlier. Preserve the existing module loader and split changes by concern.

## Waybar

Waybar renders the desktop status bar. This repository separates the bar layout (`dot_config/waybar/config.jsonc`), module definitions (`dot_config/waybar/modules.jsonc`), GTK CSS (`dot_config/waybar/style.css`), and helper scripts.

- [Upstream repository](https://github.com/Alexays/Waybar) — official project home; Waybar has no separate official website.
- [Official wiki](https://github.com/Alexays/Waybar/wiki) — documentation index.
- [Configuration](https://github.com/Alexays/Waybar/wiki/Configuration) — bar-level and shared module options, JSONC syntax, includes, signals, and reload behavior.
- [Modules](https://github.com/Alexays/Waybar/wiki/Modules) — index of built-in, compositor-specific, hardware, media, and custom modules.
- [Styling](https://github.com/Alexays/Waybar/wiki/Styling) — GTK CSS selectors, states, and supported styling behavior.
- [Examples](https://github.com/Alexays/Waybar/wiki/Examples) — upstream-maintained configuration examples for reference.
- [Manual-page sources](https://github.com/Alexays/Waybar/tree/master/man) — canonical module documentation synced to the wiki.
- [Releases](https://github.com/Alexays/Waybar/releases) — changes and compatibility notes.

Validate JSONC structure and CSS syntax separately. When changing visible modules, preserve consistent spacing, typography, colors, hover states, and alignment with the rest of the desktop.

## Rofi

Rofi provides application launching, window switching, dmenu-compatible selection, and script-driven menus. Configuration and themes use the Rasi format, normally under `~/.config/rofi/` and therefore under `dot_config/rofi/` when managed by this repository.

- [Documentation home](https://davatorium.github.io/rofi/) — versioned man pages and guides.
- [Configuration guide](https://davatorium.github.io/rofi/CONFIG/) — config location, Rasi syntax, imports, and generated defaults.
- [Current rofi manual](https://davatorium.github.io/rofi/current/rofi.1/) — modes, command-line options, and runtime behavior.
- [Theme manual](https://davatorium.github.io/rofi/current/rofi-theme.5/) — widget hierarchy, properties, selectors, states, and theme loading.
- [Script-mode manual](https://davatorium.github.io/rofi/current/rofi-script.5/) — protocol for custom script modes.
- [Upstream repository](https://github.com/davatorium/rofi) and [releases](https://github.com/davatorium/rofi/releases) — source, issues, and version history.

Prefer the man pages for exact current behavior. Use `rofi -dump-config` and `rofi -dump-theme` to inspect defaults, but keep committed configuration focused rather than storing generated files wholesale.
