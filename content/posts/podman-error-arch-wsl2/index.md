+++
title       = "Podman Error Arch WSL2: newuidmap: Could not set caps"
description = "Fix the 'newuidmap: Could not set caps' error when running Podman on Arch WSL2."
summary     = "Fix the 'newuidmap: Could not set caps' error when running Podman on Arch WSL2."
keywords    = ["podman", "wsl2", "arch", "linux", "container"]
date        = "2025-06-21T15:00:00-04:00"
publishDate = "2025-06-21T15:00:00-04:00"
lastmod     = "2025-06-21T15:00:00-04:00"
draft       = false
aliases     = []
featureAlt  = "The output from the hello-world Podman container."

# Taxonomies.
categories = []
tags       = []
+++

When I'm not using my Linux workstation I run Arch using WSL2 on my Windows
workstation. WSL2 has come a long way but this post isn't about that.

I went to write a blog post and I needed a container engine to build the
container this website runs in. My container engine of choice is Podman so I
installed Podman in Arch like so.

```
sudo pacman -S podman
```

When I ran Podman I was greeted with this lovely `newuidmap: Could not set caps`
error.

```sh
> podman run hello-world
WARN[0000] "/" is not a shared mount, this could cause issues or missing mounts with rootless containers
ERRO[0000] running `/usr/sbin/newuidmap 410 0 1000 1 1 100000 65536`: newuidmap: Could not set caps
Error: cannot set up namespace using "/usr/sbin/newuidmap": should have setuid or have filecaps setuid: exit status 1
```

I asked AI and searched the Internet and I found
[moby/moby#41812](https://github.com/moby/moby/issues/41812) which
suggested to set `CAP_SETUID` and `CAP_SETGID` on `/usr/bin/newuidmap` and
`/usr/bin/newgidmap` respectively.

```
sudo setcap cap_setuid+ep /usr/bin/newuidmap
sudo setcap cap_setgid+ep /usr/bin/newgidmap
```

Then I found
[containers/podman#12147](https://github.com/containers/podman/issues/12147)
that suggested to reinstall the `shadow` package and restart the WSL2 virtual
machine.

I reinstalled the `shadow` package.

```
sudo pacman -S shadow
```

Then restarted the WSL2 virtual machine.

```
wsl --terminate arch
```

Now Podman works!

```sh
> podman run hello-world
!... Hello Podman World ...!

         .--"--.
       / -     - \
      / (O)   (O) \
   ~~~| -=(,Y,)=- |
    .---. /`  \   |~~
 ~/  o  o \~~~~.----. ~~
  | =(X)= |~  / (O (O) \
   ~~~~~~~  ~| =(Y_)=-  |
  ~~~~    ~~~|   U      |~~

Project:   https://github.com/containers/podman
Website:   https://podman.io
Desktop:   https://podman-desktop.io
Documents: https://docs.podman.io
YouTube:   https://youtube.com/@Podman
X/Twitter: @Podman_io
Mastodon:  @Podman_io@fosstodon.org
```
