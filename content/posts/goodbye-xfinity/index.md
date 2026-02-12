+++
title       = "Goodbye Xfinity"
description = "Recounting my experience switching from Xfinity to Optimum Fiber."
summary     = "Recounting my experience switching from Xfinity to Optimum Fiber."
keywords    = []
date        = "2026-02-02T00:48:29-05:00"
publishDate = "2026-02-02T00:48:29-05:00"
lastmod     = "2026-02-09T18:00:00-05:00"
draft       = false
aliases     = []
featureAlt  = "An internet speed test showing 3.1 Gbps download and 2.0 Gbps upload."

# Taxonomies.
categories = []
tags       = []
+++

I was an Xfinity customer for 9 years. At least that's what it said when I
logged into my account. I'm not a customer any longer, though, now that Optimum
Fiber is available in my area. Switching was pretty simple, but I did lose some
features. Let's talk about it.

I live in New Jersey, home to many technical inventions like the transistor.
However, New Jersey is hilariously behind when it comes to internet service
providers (ISPs). I'll spare you the details, but basically each municipality
has agreements with different ISPs that gives an ISP exclusive access to that
municipality. If you have the misfortune of living in a municipality with a poor
ISP, like I did, there's not much you can do outside of notifying your elected
officials.

I heard on social media that Optimum Fiber was coming to my municipality but I
didn't realize it would be so quick. I was surprised when Skylar knocked on my
door and handed me a paper listing a $40/month offer for Optimum Fiber 1000/1000
with a bunch of fineprint beneath. I was already paying $121/month for Xfinity
2000/300 so I figured this would be a great opportunity to both stick it to
Xfinity and save myself some money. I ended up signing up for Optimum Fiber
5000/5000 for $75/month.

## Notes for the Non-Technical Reader

I shared this post on a local Facebook group via my wife's Facebook account.
That audience is non-technical compared to the typical audience on this blog.
This section is for those non-technical people.

For 99% of people, switching from Xfinity to Optimum Fiber is going to work
just fine. You sign up for the service, get a technician to install the fiber,
and use their provided equipment as your Wi-Fi access point and router. If you
already have your own Wi-Fi access point or router, just tell the technician
you want to use your equipment instead. That's it! Enjoy your cheaper, faster
service and send the signal to Xfinity that their service is no longer needed.

The rest of this blog post is for those who wish to better understand the
technical details of how Optimum works compared to Xfinity. If I were you and
were considering switching, I'd ask the most technical person in your house,
or whoever will be installing your service, to read the rest of this post.
Perhaps the details will be of value to them and allow them to make better,
or different, technical decisions for your installation. It's good to be well
informed.

## Comparing Optimum Fiber to Xfinity

If you're looking to switch from Xfinity to Optimum Fiber you should take note
of the following, especially if you're technical like me.

* You're forced to use Optimum's equipment. It terminates fiber and provides you
with a CAT6 RJ45 port for WAN access. However, after the first year Optimum will
add $5/month as an equipment rental charge. Think again! You best believe I'll
be calling them up to either cancel or drop that charge when my 1 year comes
up. Lame!

* If you want to use your own router behind Optimum's equipment you'll have to
contact Optimum and ask them to switch the equipment into bridge mode. While
you're there you may also want to ask them to disable the Wi-Fi. Both of these
settings are only accessible to Optimum. You cannot control this device outside
of the default Wi-Fi SSID and password. Lame!

* Optimum's equipment has an SFP+ port, but direct attach cables didn't work
for me. I connected my UniFi gateway to the SFP+ port, but I was unable to pull
a public IPv4 address. When I switched back to using their SFP+ to RJ45 adapter
everything worked. To troubleshoot further I switched the adapters to have their
adapter plugged into my SFP+ port and my adapter plugged into their SFP+ port.
No dice. They must have logic in their firmware to assert on the adapter. Lame!

* Optimum's equipment is not rack mountable. Sure, you could likely fit it on a
1U rackmount shelf, but the unit itself does not have any mechanism to rackmount
it. This is likely not a concern for most people but it was for me since I
already had a rackmount cable modem I was using with Xfinity. The equipment also
has a sticker on it saying to keep it upright. Now I have a silly upright box on
top of my rack. Lame!

* Optimum Fiber doesn't support IPv6. I'm sure at some point in the future it
will support IPv6, but today it doesn't. I never thought I'd be saying anything
nice about Xfinity, but they supported IPv6 just fine. I'm not going to use
some IPv6 transition service like Optimum suggested. My equipment is perfectly
capable of IPv6. Optimum's equipment should be too. Lame!

* Optimum Fiber has really good performance. I'm seeing unloaded and loaded
latency under 5ms and 3000/3000 speeds with my 5000/5000 plan. Of course you'll
need a router with at least a 2.5 GbE port to take advantage of speeds over 1000
but you already knew that. My WAN port is linked at 10 GbE so I'm good.

## Should You Switch?

Probably! Brand loyalty does nothing except give the brand itself a reason to
be complacent. I recommend switching to send a signal to poor ISPs like Xfinity
that their overpriced, underperforming service is not worth it anymore.

In my case I asked Skylar a ton of questions before I committed to anything.
I knew that I would lose rackmount access and IPv6, but I would lower my
monthly bill and gain an upload speed that I've never seen before in my life,
which proved to be extremely helpful when uploading large images during Oxide
development.

Even so, I'll be reevaluating my decision in a year from now when Optimum tries
to charge me for the equipment they are forcing me to use. Hopefully by then
they will have IPv6 but I'm not hopeful. I'm also not hopeful in contacting
their customer support based on what I've read online and what I've already
experienced with Xfinity.

For now, though, I'll enjoy the 5000/5000 service.
