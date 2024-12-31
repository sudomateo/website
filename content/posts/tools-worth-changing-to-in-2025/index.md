+++
title       = "Tools Worth Changing To in 2025"
description = "Change your tools and change your life in 2025."
summary     = "Change your tools and change your life in 2025."
keywords    = ["tools", "ghostty", "fish", "helix", "hx", "jujutsu", "jj", "zed", "nix", "nixos", "ollama", "ai", "llm"]
date        = "2024-12-31T11:16:49-05:00"
lastmod     = "2024-12-31T11:16:49-05:00"
publishDate = "2024-12-31T11:16:49-05:00"
draft       = false
aliases     = []

# Taxonomies.
categories = []
tags       = []
+++

It's almost 2025 in my part of the world and that means another year has gone
by. Another year of love. Another year of joy. 2024 was a great year for
me and my family overall. There were highs- we opened a physical location for
my wife's chocolate business, [Lily & Sparrow][1], and I joined the team at
[Oxide Computer Company][2]. There were lows- one of our dogs passed away and we
adopted another shortly after.

If there's one thing I've learned in life it's that the highs and lows come
whether you're prepared for them or not. I also learned that the highs and lows
both manifest in the same way- through change. This post isn't meant to be a
philosophy of change but I did want to mention one thing. People often think
about change from the perspective of things outside of their control (e.g.,
our dog passing away). I want to challenge you to think about change from the
perspective of things that you can control (e.g., your behavior).

You can change yourself. You can change what you do, what you say, and even how
you think. It's healthy to reevaluate yourself every now and again and think
about what you can and should change. I do this myself both personally and
professionally. In this post I want to share with you the professional changes
I've made, or will be making, to my tools and encourage you to reflect and
change your own tools in the new year.

Let's see which tools are worth checking out in 2025.

## Ghostty

[Ghostty][3] is a fast, feature-rich, and cross-platform terminal emulator that
uses platform-native UI and GPU acceleration. It's written in Zig and created by
[Mitchell Hashimoto][4] who co-founded HashiCorp, a previous employer of mine.
Ghostty was publicly released in December 2024 but I've been using Ghostty as
my terminal emulator well before that during its beta period. Ghostty has since
become my primary terminal emulator, replacing GNOME Terminal and Alacritty.

Terminal emulators are meant to be functional, stable, and out of the way by
design so you might be wondering why I even listed Ghostty. After all, there
are dozens of terminal emulators out there that work perfectly well. What makes
Ghostty special? Honestly, nothing. Ghostty isn't special. It's not trying to
reinvent terminal emulators with some flashy new feature or gimmick. Instead, in
my opinion, Ghostty aims to _reimplement_ terminal emulators with the goals of
being native, feature-rich, and fast.

Here's why I like Ghostty and believe you should give it a try.

- It's cross-platform and native. Ghostty works across macOS and Linux with
Windows support being discussed in [ghostty-org/ghostty#2563][5]. I have the
same experience across all my machines without Ghostty feeling like a macOS app
on Linux or vice versa. Ghostty feels like it belongs on the machine.
- The configuration is optional, yet extensive. Ghostty follows a zero
configuration philosophy which means it's designed to work out of the box with
no configuration necessary for most users. However, when configuration is needed
there are a multitude of configuration options ready to be used in a simple
key-value format. No TOML, YAML, JSON, HCL (Sorry Mitchell!), or other DSL to
learn.
- It's fast. Like "oops I just accidentally ran `cat /bin/sh` and my terminal
didn't hang" fast. As someone who uses a terminal text editor and spends most
of their working day in a terminal emulator, having a fast terminal emulator is
a necessity.
- The potential of `libghostty`. The Ghostty architecture is a core library
named `libghostty` with native GUI applications (e.g., SwiftUI on macOS, GTK on
Linux) that consume it. That means other applications can use `libghostty` to
provide a terminal emulator to their users without having to implement all the
difficult stuff! Imagine Zed or VS Code using Ghostty as their embedded terminal
emulator.
- The maintainer is friendly with a clear vision. Mitchell is the
[self-proclaimed][6] benevolent dictator for life for now (BDFLFN) and has set
a clear vision for Ghostty. Contributions and discussions are welcome and the
Ghostty Discord community is active. It's refreshing to see a healthy community
with someone at the helm who welcomes community feeback, especially after reading
how another maintainer responded in [alacritty/alacritty#3926][7].

## Fish

[Fish][8] is a smart and user-friendly command line shell for Linux, macOS,
and the rest of the family. I started using fish full-time in 2024 after a
decade of using bash with a sprinkle of zsh mixed in. Bash was perfectly fine
for my use case- it was a POSIX shell that I had configured perfectly to my
minimalist taste. Zsh, on the other hand, took forever to start with the Oh My
Zsh framework that left a bad taste in my mouth. Sorry zsh, I know it wasn't
your fault.

If bash was fine and zsh wasn't it then why did I switch to fish? The answers
are simple, if not a bit subjective.

- Fish has fantastic autosuggestions that are based on your command history,
configured completions, and file paths. This all works out of the box with zero
configuration necessary. Yes I know things like [Atuin][9] exist but that's
only for shell history and I'm not someone that needs my history across multiple
machines. In fact, I `history clear` every so often anyway! Yes, go ahead, look
at me like I'm a monster.
- Fish supports the [XDG Base Directory Specification][10]. I can declutter
my home directory and make my configuration more modular and easy to reason
about. Admittedly I'm still in progress on this but it's better than a large
`~/.bashrc` file or some sourcing logic with `.`.
- Fish has nice builtins and the syntax feels like a programming language. I'm
no stranger to the bash syntax but it does get pretty frustrating having to look
up the syntax for string substitution or pipe things to `sed`. Fish has a nice
`string` builtin for that. Fish feels more like Python and Ruby than bash.
- Fish is actively maintained. Okay, I know pretty much every shell is actively
maintained but fish is in the middle of a [rewrite from C++ to Rust][11]. I'm
not one to choose programs solely based on the language they are written in but
I do work at a company that largely uses Rust and any maintainer willing to do a
rewrite of their program has my respect. Not because it's difficult but because
it shows a level of care and detail for all parts of the code, even the parts
that haven't been touched in a while.

## Helix

[Helix][12] is a "post-modern" text editor with inspirations from [Kakoune][13]
and [Neovim][14]. If you're coming from Neovim, like I was, think of Helix as
Neovim without needing plugins for common configuration. Helix is all about
selections and it flips Neovim's motion-verb-noun design into motion-noun-verb.
For example, deleting 2 words in Neovim is `2dw` while in Helix it's `v2wd`.

I switched to Helix a few weeks before writing this post so I'm still
familiarizing myself with it. I'll give myself another month or so before
decidiing if I'll stay or switch back to Neovim. Here's what I'm liking so far.

- Common configuration is built in. Helix doesn't require plugins for LSP
configuration, tree-sitter, or fuzzy finding. All of that is built into
Helix and can be overriden on a per-user or per-project basis. I'm primarily
working in Go and Rust these days and those languages work extremely well out
of the box. I do miss `mason.nvim` to manage my language server and linter
installations, but I can live without it.
- Helix is fast. Coming from Neovim I already had a fast editor but when I
opened Helix to do its `:tutor` I was impressed with how responsive it was.
That's not surprising to me given that Helix is written in Rust but it's nice to
see it in action. I surely don't miss the days when VS Code would take seconds
to open and crash when viewing large files. How do people live like that?
- Helix has useful features and a context menu when keys are pressed. I can
use `C` to add multiple cursors and then insert text or select text and modify
it. I don't use multiple cursors often but it's pretty convenient in places
where I'd normally have to resort to a Neovim macro. I do use Helix's surround
integration often though. I press `mi"` to select text within double quotes
and `ms{` to surround the selected text with braces. If you don't know what to
do, simply press a key and Helix will show a menu of possible options similar
to `which-key.nvim`.

## Jujutsu

[Jujutsu][15] is a version control system that can be used with, or in place
of, Git. Jujutsu is unique in that it separates the user experience of version
control from the underlying storage system storing the bytes. This allows
Jujutsu to work with Git repositories by using Git as a storage backend, making
it seamless to experiment with.

Jujutsu is... _different_. It doesn't have a concept of named branches but
instead operates like a detached HEAD with commits, undo functionality, and
automatic rebase and conflict resolution. Covering the features of Jujutsu
warrants its own blog post so if you're looking to try it out I recommend
reading [Steve Klabnik's Jujutsu Tutorial][16]. I've replaced `git` with `jj`
entirely in my personal and professional use. Here's why I really like it.

- Freedom from named branches. I can just work on revisions as necessary
_before_ coming up with a name for what I'm doing. I can edit previous revisions
directly, rebase them, or squash them. Then when I'm ready to create a pull
request on GitHub I can name my revision with a bookmark and I'm all set.
- It's simple to use. It takes a second to get used to Jujutsu's syntax but once
you do it's simple to use. You can just `jj new` and `jj commit` your way around
and `jj undo` if you do something you didn't mean to.
- Git compatibility. It's tough creating a new tool when an incumbent tool
exists. It's even tougher to make that tool compatible with the incumbent tool
while introducing new features. Jujutsu does a great job at both.

## Zed

[Zed][17] is a next-generation code editor designed for high-performance
collaboration with humans and AI. Zed is written in Rust and was created by a
developer from Atom, an editor I used to use before Microsoft ~~axed it in favor
of VS Code~~ sunset it.

I have Zed installed and have tried it for some development work but ultimately
I'm a terminal editor person at heart so I don't use Zed as a daily driver. I am,
however, excited for the future of Zed and that's why it's on this list. Perhaps
it can replace your editor. Here are some reasons you'd might want to switch.

- Zed is fast. Zed focuses a lot on performance and is one of the fastest
graphical editors out there. If you're over the slowness of VS Code then Zed
might be for you.
- Zed has first-party support for collaboration and AI. There are text and voice
chats- bye bye VS Code Live Share- and support for AI prompts and code editing.
I used Zed with Ollama, Anthropic, and OpenAI and it was a pleasant experience.
- Zed has many extensions. The Zed developers and community created a ton of
extensions for all popular use cases. If extensions are what you like about your
editor then Zed's got you covered.

## Nix

[Nix][18] is a tool that provides declarative builds, deployments, and system
configuration for Unix-like systems. Nix has a high learning curve but I'm told
once you get over that learning curve you'll be rewarded with the ultimate Linux
experience. Nix is highly regarded by those who use it and an operating system,
NixOS, was created using Nix as its core method for system configuration.

I can't list what I like about Nix since I haven't yet taken the time to learn
it but it's something I look forward to learning in 2025.

## Ollama

[Ollama][19] is a program to run large language models (LLMs) locally on
your machine. I use Ollama to run models such as `llama3.3`, `mistral`, and
`codellama`. In fact, Ollama is the primary way that I interact with LLMs
nowadays after I got tired of deciding whether to pay for Anthropic or OpenAI
each month. There's really not much to say here other than AI is a useful tool
to add to one's toolbelt. I like Ollama for the following reasons.

- It's local. I don't need internet connectivity to use Ollama which makes it
great when working on trains, planes, or any other place where your network
connection is unreliable.
- It's fast, with a GPU. I run Ollama with a GTX 1080ti on my desktop and an
RX 7700S on my Framework 16 and the speed is great! When I remove the GPU on my
laptop, which is something I can do with the Framework 16, the speed of Ollama
takes a hit but it's still acceptable for most use cases.
- It's riding the AI wave. AI isn't going away anytime soon and Ollama stays
up to date with popular models and other community trained models. I believe
you can train your own model with Ollama but I haven't had time to test that.
Perhaps I will soon but for now I enjoy the model updates.

## Final Thoughts

I hope this post inspired you to change things about your life. Start with your
tools and then move to yourself. Happy New Year everyone!

[1]: https://lilyandsparrow.net "Lily & Sparrow"
[2]: https://oxide.computer "Oxide Computer Company"
[3]: https://ghostty.org/ "Ghostty Terminal Emulator"
[4]: https://mitchellh.com/ "Mitchell Hashimoto"
[5]: https://github.com/ghostty-org/ghostty/discussions/2563 "Ghostty Windows Support"
[6]: https://changelog.com/podcast/622#t=2278 "We ain't afraid of no Ghostty!"
[7]: https://github.com/alacritty/alacritty/issues/3926 " Alacritty icon concept for macOS Big Sur"
[8]: https://fishshell.com/ "Fish Shell"
[9]: https://atuin.sh/ "Atuin"
[10]: https://specifications.freedesktop.org/basedir-spec/latest/ "XDG Base Directory Specification"
[11]: https://fishshell.com/blog/rustport/ "Fish 4.0: The Fish of Theseus"
[12]: http://helix-editor.com "Helix"
[13]: http://kakoune.org/ "Kakoune"
[14]: https://neovim.io/ "Neovim"
[15]: https://jj-vcs.github.io/jj "Jujutsu"
[16]: https://steveklabnik.github.io/jujutsu-tutorial/ "Steve's Jujutsu Tutorial"
[17]: https://zed.dev "Zed"
[18]: https://nix.dev "Nix"
[19]: https://ollama.com/ "Ollama"
