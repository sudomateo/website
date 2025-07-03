+++
title       = "Functional Keys with X Keyboard Extension (XKB)"
description = "Use the X keyboard extension to restore F13-F24 key functionality."
summary     = "Use the X keyboard extension to restore F13-F24 key functionality."
keywords    = ["XKB", "macropad"]
date        = "2024-12-28T00:00:00-05:00"
publishDate = "2024-12-28T00:00:00-05:00"
lastmod     = "2024-12-28T00:00:00-05:00"
draft       = false
aliases     = []
featureAlt  = "A Keebio Chocopad 4x4 keyboard with blank keycaps and red backlighting."

# Taxonomies.
categories = []
tags       = []
+++

I received a [Keebio][1] Chocopad for Christmas. The Chocopad is a 4x4
keyboard that runs QMK firmware and can be programmed using the CLI or a VIA
configurator. It's a great device that's even smaller than I anticipated and
took me no longer than 5 minutes to assemble and flash. It did, however, take
much longer than 5 minutes to properly configure for my use case. Oh, Linux.
 
## The Plan

I planned to use the Chocopad as a macropad for OBS and other applications to
perform actions such as toggle mute, switch scenes, etc. I'm running Linux so
devices like the Elgato Stream Deck aren't compatible and cost too much money
for my taste.

Before configuring the Chocopad I had to decide which keys I wanted to use.
After 30 minutes of research I decided to use function keys F13-F24 as they had
a low possibility of conflicting with other keyboard shortcuts. For the keen
reader, yes, there are function keys above F12.

I flashed the Chocopad with function keys F13-F24, opened OBS to configure
hotkeys, and... nothing. OBS did not recognize F13-F24 and I had no idea
why. Being a great engineer, I performed a test and flashed the Chocopad with
alphanumeric keys 0-9. OBS recognized those keys and let me configure hotkeys.
Success, I guess, but what's going on with F13-F24?

## The Pain

Even though OBS didn't recognize F13-F24 my operating system recognized them
just fine. For example, when I pressed F13 my Settings application opened and
when I pressed F20 my microphone toggled mute. Clearly the actual key presses
were working but my operating system was interpreting those key presses as
something else. I had to figure out what exactly the operating system was
registering for each key press.

Before I continue let's describe the journey from a key press on the keyboard to
a character in the application. We'll assume Linux and keep the details light as
I'm sure I'll get a "well, actually" comment from _someone_. Regardless, here's
the high-level journey.

1. A key is pressed on a keyboard.
1. The keyboard translates this key press to a **keycode** and sends it to the
operating system.
1. The operating system uses its input system to read the keycode.
1. The operating system uses its event device (`evdev`) framework to translate
the keycode into a **key** of event type `EV_KEY`.
1. The display system (e.g., X11, Wayland) uses a **keymap** to translate the
key into a **character**.
1. The application uses the character however it sees fit.

Armed with this knowledge I decided to approach this top-down and find out how
Wayland is registering my key presses. I quickly found the `wev` command and its
output was quite helpful.

Pressing F13 registered as `XF86Tools`.

```
[14:     wl_keyboard] key: serial: 48984; time: 14200463; key: 191; state: 0 (released)
                      sym: XF86Tools    (269025153), utf8: ''
```

Pressing F20 registered as `XF86AudioMicMute`.

```
[14:     wl_keyboard] key: serial: 48987; time: 14203425; key: 198; state: 0 (released)
                      sym: XF86AudioMicMute (269025202), utf8: ''
```

If this is what Wayland saw then these mappings must be configured in my keymap.
Enter [X keyboard extension (XKB)][2]. XKB is responsible for, well, extending
keyboard functionality through keymaps and other configuration. A quick search
showed me how to print information from XKB. Specifically, where the keymap
rules were configured.

```
> setxkbmap -print -verbose 10
...
Trying to load rules file ./rules/evdev...
Trying to load rules file /usr/share/X11/xkb/rules/evdev...
...
```

The output showed that rules are loaded from `/usr/share/X11/xkb/rules/evdev`.
Searching at that location and its parent directories for
`XF86Tools|XF86AudioMicMute` led me to `/usr/share/X11/xkb/symbols/inet`
where I could easily see that F13 mapped to `XF86Tools` and F20 mapped to
`XF86AudioMicMute`.

```
> rg -N 'XF86Tools|XF86AudioMicMute' /usr/share/X11/xkb
/usr/share/X11/xkb/symbols/inet
    key <FK20>   {      [ XF86AudioMicMute      ]       };
    key <FK13>   {      [ XF86Tools         ]       };
```

Great, but how does `/usr/share/X11/xkb/rules/evdev` relate to
`/usr/share/X11/xkb/symbols/inet`?

In `/usr/share/X11/xkb/rules/evdev` there's the following block.

```
! model         =       symbols
  chromebook    =   +inet(evdev)+inet(chromebook)
  ppkb          =   +inet(evdev)+inet(ppkb)
  *             =   +inet(evdev)
```

That last line tells XKB to load the `evdev` block within the
`/usr/share/X11/xkb/symbols/inet` symbols file. Inspecting the file showed that
the `evdev` block contained the mappings that I found earlier.

```
xkb_symbols "evdev" {
    key <FK20>   {      [ XF86AudioMicMute      ]       };
    key <FK13>   {      [ XF86Tools         ]       };
    // ...
}
```

As a test I updated the mappings within `/usr/share/X11/xkb/symbols/inet` to the
following and rebooted my machine.

```
xkb_symbols "evdev" {
    key <FK20> { [ F20 ] };
    key <FK13> { [ F13 ] };
    // ...
}
```

Oh yeah! It worked! The `wev` command confirmed it.

```
[14:     wl_keyboard] key: serial: 30886; time: 13123238; key: 191; state: 1 (pressed)
                      sym: F13          (65482), utf8: ''
[14:     wl_keyboard] key: serial: 30887; time: 13123329; key: 191; state: 0 (released)
                      sym: F13          (65482), utf8: ''
[14:     wl_keyboard] key: serial: 30888; time: 13124813; key: 198; state: 1 (pressed)
                      sym: F20          (65489), utf8: ''
[14:     wl_keyboard] key: serial: 30889; time: 13124925; key: 198; state: 0 (released)
                      sym: F20          (65489), utf8: ''
```

You're probably wondering where the pain is, aren't you? After all
this section is titled "The Pain" and it seems like I could just modify
`/usr/share/X11/xkb/symbols/inet` and be on my merry way, right? Of course
not! This is Linux and that means I have to spend hours configuring things, not
minutes. Seriously, I spent around 4 hours figuring all this out. Here's a quick
summary of the pain I dealt with.

Yes, I could have just modified `/usr/share/X11/xkb/symbols/inet` and things
would have worked well. That is, until the next system upgrade where that file
is regenerated, overwriting my changes. I had to find a way to configure things
at the user level instead of the system level.

Most of the resources available online for XKB user configuration or remapping
F13-F24 keys were honestly noise and a waste of time. Specifically, the forum
posts and GitHub issues where people posted vague replies or found their answer
and never posted it for everyone to benefit. Don't be like this. Do better and
write things down please. The only resources that were worth it in my opinion
were the following.
  - [`libxkbcommon` User Configuration][3]
  - [User-specific XKB configuration - part 1][4]
  - [User-specific XKB configuration - part 2][5]
  - [User-specific XKB configuration - part 3][6]
  - [User-specific XKB configuration - putting it all together][7]
  - [Wayland change your keyboard layout with xkb and gnome tweaks][8] 

Even though I now knew how to configure XKB using user configuration I
struggled for a while to find a fast feedback loop to test my changes. At first
I was rebooting but that took far too long. Then I switched to logging out.
Finally I found out that I could use `gsettings` to reset and configure my XKB
options live. More on that in the next section.

## The Program

This post is already longer than I anticipated so I'll do my best to briefly
describe what I did. I had 2 goals going into this.

1. Configure function keys F13-F24 to register as F13-F24 instead of silly
things like `XF86Tools` or `XF86AudioMicMute`.
1. Perform this configuration persistently and irrespective of system
configuration that could be overwritten on update.

XKB uses `libxkbcommon` to load user configuration from `$XDG_CONFIG_HOME/xkb`.
The directory structure within should mirror what is found at
`/usr/share/X11/xkb`. Here's what I ended up with.

```
$XDG_CONFIG_HOME/xkb
├── rules
│   ├── evdev
│   └── evdev.xml
└── symbols
    └── sudomateo
```

The updated mappings were located in `symbols/sudomateo`. These mappings
configured function keys F13-F24 to register as F13-F24.

```
partial alphanumeric_keys
xkb_symbols "function_keys" {
    key <FK13> { [ F13 ] };
    key <FK14> { [ F14 ] };
    key <FK15> { [ F15 ] };
    key <FK16> { [ F16 ] };
    key <FK17> { [ F17 ] };
    key <FK18> { [ F18 ] };
    key <FK19> { [ F19 ] };
    key <FK20> { [ F20 ] };
    key <FK21> { [ F21 ] };
    key <FK22> { [ F22 ] };
    key <FK23> { [ F23 ] };
    key <FK24> { [ F24 ] };
};
```

These updated mappings were loaded by `rules/evdev`. The last line exposes a
new XKB option named `sudomateo:function_keys` with the symbols defined from the
`function_keys` block within the `symbols/sudomateo` file.

```
// Include the system `evdev` file.
! include %S/evdev

// Configure custom symbols. This is configured after including the system
// `evdev` file so the changes aren't overridden by the system configuration.
! option = symbols
  sudomateo:function_keys = +sudomateo(function_keys)
```

With those files in place I could now use `gsettings` to reset and configure my
XKB options live.

```
# Reset.
gsettings reset org.gnome.desktop.input-sources xkb-options

# Configure.
gsettings set org.gnome.desktop.input-sources xkb-options "['sudomateo:function_keys']"
```

I could have also used GNOME Tweaks to configure this but that requires
`rules/evdev.xml` to tell GNOME which XKB options are available. I also
prefer the CLI to the GUI so I didn't end up using this.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xkbConfigRegistry SYSTEM "xkb.dtd">
<xkbConfigRegistry version="1.1">
  <optionList>
    <group allowMultipleSelection="true">
      <configItem>
        <name>Matthew Sanabria</name>
        <description>Matthew Sanabria's custom options</description>
      </configItem>
      <option>
        <configItem>
          <name>sudomateo:function_keys</name>
          <description>Map FK13-FK24 to F13-F24</description>
        </configItem>
      </option>
    </group>
  </optionList>
</xkbConfigRegistry>
```

## Final Thoughts

I know what you're thinking right now. All of _that_ for a keymap? Trust me, I
get it. If I were running macOS or Windows I could have just bought a supported
macropad and used its software to configure it for OBS and other applications.
While I ended up spending more time than I wanted to on this, and even more
since I also wrote this post, it was worth it for me. I learned a lot about how
my Linux system and XKB works and I was able to write up my findings to help
future readers. All that's left is to optimize this post for search engines so
that future readers can find it and not waste as much time as I did researching
things.

Okay, let me go actually use this Chocopad now. Bye!

[1]: https://keeb.io "Keebio"
[2]: https://en.wikipedia.org/wiki/X_keyboard_extension "X keyboard extension"
[3]: https://xkbcommon.org/doc/current/user-configuration.html "`libxkbcommon` User Configuration"
[4]: https://who-t.blogspot.com/2020/02/user-specific-xkb-configuration-part-1.html "User-specific XKB configuration - part 1"
[5]: https://who-t.blogspot.com/2020/07/user-specific-xkb-configuration-part-2.html "User-specific XKB configuration - part 2"
[6]: https://who-t.blogspot.com/2020/08/user-specific-xkb-configuration-part-3.html "User-specific XKB configuration - part 3"
[7]: https://who-t.blogspot.com/2020/09/user-specific-xkb-configuration-putting.html "User-specific XKB configuration - putting it all together"
[8]: https://youtu.be/utqpa_8SXkA "Wayland change your keyboard layout with xkb and gnome tweaks"
