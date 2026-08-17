# Enable Optional Metapac Groups

Some metapac groups are stored in this repository but are not enabled on every
machine. The local chezmoi configuration selects these groups through the
`optional_metapac_groups` template data.

Use this workflow only for a group that already exists under
`dot_config/metapac/groups/`. For example, this repository includes optional
groups such as `gamedev`, `gaming`, and `local-llm`.

## Configure the machine

Open the machine-local chezmoi configuration:

```bash
chezmoi edit-config
```

Add the group names under `[data]`. Preserve any groups that are already in the
list:

```toml
[data]
optional_metapac_groups = [
  "gamedev",
  "gaming",
  "local-llm",
]
```

The names omit the `.toml` extension. This setting belongs in the local
chezmoi configuration rather than `.chezmoidata.toml`, so each machine can
choose its own optional groups without changing the repository defaults.

## Preview and apply the rendered configuration

Review the resulting change before writing it to the home directory:

```bash
chezmoi diff ~/.config/metapac/config.toml
chezmoi apply --dry-run --verbose ~/.config/metapac/config.toml
```

The rendered `~/.config/metapac/config.toml` should add the selected names to
the current machine under `[hostname_groups]`. Apply only that configuration
file when the preview is correct:

```bash
chezmoi apply ~/.config/metapac/config.toml
```

Confirm the rendered hostname group list:

```bash
rg --after-context 30 '^\[hostname_groups\]$' ~/.config/metapac/config.toml
```

Review the selected files under `~/.config/metapac/groups/`, then install any
missing packages they declare:

```bash
metapac sync
```

## Disable an optional group

Run `chezmoi edit-config` again and remove the group name from
`optional_metapac_groups`. Preview and apply `~/.config/metapac/config.toml` as
above.

Disabling a group does not uninstall its packages. `metapac clean` can remove
unmanaged packages, but it may propose broad removals; inspect its complete
removal plan before confirming it.

For upstream details, see the
[chezmoi `edit-config` reference](https://www.chezmoi.io/reference/commands/edit-config/)
and the [metapac documentation](https://docs.rs/metapac/latest/metapac/).
