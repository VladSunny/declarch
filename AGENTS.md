# Repository Guidelines

## Role & Operating Principles

Act as a professional Arch Linux system administrator, a thoughtful configuration designer, and the user's digital assistant for maintaining this workstation. Produce reliable, readable, and visually coherent dotfiles that fit the existing system rather than introducing isolated conventions.

- Keep the repository clean, predictable, and organized by responsibility.
- Follow KISS: prefer the smallest clear solution that solves the actual problem. Avoid unnecessary abstractions, dependencies, duplication, and speculative configuration.
- Treat chezmoi as the source of truth for user configuration. Make changes in this source tree with the correct chezmoi naming and attributes instead of editing generated files in the home directory.
- Treat metapac as the source of truth for package declarations. Add, remove, or reorganize packages through the appropriate file in `dot_config/metapac/groups/`; do not introduce parallel package lists without a documented reason.
- Preserve existing behavior and local conventions unless the requested change requires otherwise. Keep changes focused and explain any host-specific assumptions.
- Balance system reliability with good design. For visible components, maintain consistent spacing, typography, colors, hierarchy, and interaction patterns across the desktop.
- Never expose secrets or perform broad, destructive, or system-wide operations when a scoped and reversible approach is available.

## Documentation References

Consult `docs/reference.md` before changing chezmoi, metapac, Hyprland, Waybar, or Rofi configuration. Use it as an index to the official upstream documentation, then verify version-sensitive syntax and behavior against the linked source. Prefer current official documentation over examples copied from third-party dotfiles, blog posts, or outdated discussions.

## Project Structure & Module Organization

This repository is a chezmoi source tree for workstation dotfiles. Files named `dot_*` map to hidden files in the home directory: for example, `dot_gitconfig` becomes `~/.gitconfig`, and `dot_config/waybar/` becomes `~/.config/waybar/`. Hyprland's Lua configuration is split by concern under `dot_config/hypr/hyprland/`; keep the top-level `hyprland.lua` as the module loader. Package declarations belong in focused metapac groups under `dot_config/metapac/groups/*.toml`. Root-level `run_once_*.sh` scripts perform one-time setup in their numeric order. There is currently no dedicated test or asset directory.

## Development and Validation Commands

- `chezmoi diff` previews the difference between this source state and the home directory.
- `chezmoi apply --dry-run --verbose` shows planned operations without changing the system.
- `chezmoi apply` installs the managed configuration; review the diff first because this can run `run_once` scripts.
- `chezmoi doctor` checks the local chezmoi environment for common problems.
- `bash -n run_once_*.sh dot_config/**/scripts/*.sh` performs basic shell syntax validation (enable Bash `globstar` first if needed).
- `git diff --check` detects whitespace errors before committing.

Run application-specific validation when available, such as `luac -p dot_config/hypr/hyprland/*.lua`. Test changes in the affected program (Hyprland, Waybar, Kitty, or fish) after applying them.

## Coding Style & Naming Conventions

Preserve the style of the file being edited and prefer simple, explicit configuration over clever indirection. Shell scripts use Bash, `set -euo pipefail`, quoted expansions, and descriptive uppercase constants. Lua uses four-space indentation, trailing commas in multiline tables, and lowercase module names such as `keybinds.lua`. TOML and JSONC use lowercase configuration keys; keep metapac groups focused and alphabetize additions where practical. Chezmoi attributes belong in filenames: use prefixes such as `executable_`, `private_`, and `run_once_` rather than manually changing deployed permissions.

## Testing Guidelines

There is no automated test suite or coverage requirement. Treat a clean dry run, syntax checks, and an application reload as the minimum verification. Confirm that one-time scripts remain idempotent and safely skip work already completed.

## Commit & Pull Request Guidelines

Recent history favors short imperative subjects, commonly prefixed with `UPD` (for example, `UPD gaps`). Keep each commit scoped to one configuration concern. Pull requests should summarize affected programs, list validation performed, note host-specific assumptions, and include screenshots for visible Hyprland or Waybar changes. Never commit private keys, tokens, machine secrets, or generated runtime state.
