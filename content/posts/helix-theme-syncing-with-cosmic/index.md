+++
title       = "Helix Theme Syncing with COSMIC"
description = "How I sync the Helix theme with COSMIC."
summary     = "How I sync the Helix theme with COSMIC."
keywords    = [""]
date        = "2025-10-07T19:00:00-04:00"
publishDate = "2025-10-07T19:00:00-04:00"
lastmod     = "2025-10-07T19:00:00-04:00"
draft       = false
aliases     = []
featureAlt  = ""

# Taxonomies.
categories = []
tags       = []
+++

I recently switched to using a light theme during the day and a dark theme
during the night. Everything works except for Helix since it does not support
automatic theme switching. See the following issues for more details if you're
curious.

* [helix-editor/helix#2158](https://github.com/helix-editor/helix/issues/2158)
* [helix-editor/helix#8899](https://github.com/helix-editor/helix/issues/8899)

I'm running Arch Linux with the COSMIC desktop environment. COSMIC is configured
to automatically switch to a light theme at sunrise and a dark theme at sunset.
When sunset occurs I immediately see Chromium and Ghostty switch to a dark
theme. Helix, however, remains on a light theme.

COSMIC doesn't make use of `gsettings` like GNOME. Instead, it has its own
settings files in `/usr/share/cosmic` and `~/.config/cosmic`. One such file
is `~/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark` which returns
`true` or `false`. Pretty convenient and self-explanatory. Let's use that to
automatically sync Helix's theme with COSMIC.

## Changing the Helix Theme

I recently switched to Nushell so I decided to write a Nushell script to do the
heavy lifting and try out some of its features. Here's the final script that I
saved to `~/bin/helix-theme-sync.nu`.

```nu
#! /usr/bin/env nu

const helix_config = ($nu.home-path | path join ".config/helix/config.toml")

# Looks complex but it's not bad.
# \K      -> Discards what came before and keeps what follows.
# (?=...) -> A lookahead to ensure what matches isn't replaced.
const regex = '^theme\s+=\s+"\K\w+(?=".*)'

let is_dark = (open ~/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark | str trim | into bool)

# We specifically use `open --raw` with `str replace` to prevent Nushell from
# changing the format of the TOML file (e.g., don't remove extra spacing).
if $is_dark {
  open --raw $helix_config | str replace --regex $regex 'gruvbox' | save -f $helix_config
} else {
  open --raw $helix_config | str replace --regex $regex 'gruvbox_light' | save -f $helix_config
}
```

I commented this for readers so I'll skip explaining it further. Ping me if it's
still unclear!

For the experienced Nushell people, yes I could have done something like the
following instead, but I didn't like that Nushell reformatted the TOML file.

```nu
const helix_config = ($nu.home-path | path join ".config/helix/config.toml")
open $helix_config | upsert theme 'gruvbox' | save -f $helix_config
```

Now I can run `helix-theme-sync.nu` and Helix will automatically use a light or
dark theme depending on what COSMIC is using. It's still a manual process though
so let's tackle that next.

## Syncing the Helix Theme Automatically

This was _far_ easier than I anticipated after I asked Claude Code how I could
better accomplish this.

I created a `~/.config/systemd/user/helix-theme-sync.service` file to call my
Nushell script and update the Helix theme. Nothing fancy here.

```ini
[Unit]
Description=Sync the Helix theme with COSMIC

[Service]
Type=oneshot
ExecStart=/usr/bin/env nu %h/bin/helix-theme-sync.nu

[Install]
WantedBy=default.target
```

The magic happens in the `~/.config/systemd/user/helix-theme-sync.path` file. To
be honest, I completely forgot about systemd `.path` unit files so I was happy
when Claude Code reminded me of them.

```ini
[Unit]
Description=Sync the Helix theme with COSMIC

[Path]
PathModified=%h/.config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark

[Install]
WantedBy=default.target
```

The way it works is the `helix-theme-sync.path` unit file watches the specified
`PathModified` file for changes. When a change is detected it will run the
systemd `.service` file of the same name (e.g., `helix-theme-sync.service`).
Super simple!

Now, I just needed to reload the systemd user unit files and enable and start
them.

```shell
systemctl --user daemon-reload
systemctl --user enable --now helix-theme-sync.service
systemctl --user enable --now helix-theme-sync.path
```

Done! Now when I change my COSMIC theme my Helix theme automatically changes.

## Questions

The keen reader might be asking themselves some questions. Let's cover them.

> What happens when the system is powered off while using the dark theme and
started up during a time when it should use the light theme?

Simple! The `helix-theme-sync.service` file contains the following
configuration.

```ini
[Install]
WantedBy=default.target
```

This means the service will run once on boot since the `default.target` is,
well, the default boot target. This will see the current COSMIC theme and update
Helix appropriately.

> Will the Helix theme change live if it's running during the update?

Nope! This would require either relaunching Helix or running `:config-reload`.
I'm fine with either of those.
