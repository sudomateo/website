+++
title       = "Own Your Email Domain"
description = "Own the most important part of your online experience."
summary     = "Own the most important part of your online experience."
keywords    = []
date        = "2025-02-01T16:00:00-05:00"
lastmod     = "2025-02-01T16:00:00-05:00"
publishDate = "2025-06-10T19:00:00-04:00"
draft       = false
aliases     = []
featureAlt  = "A user interface for composing an email message."

# Taxonomies.
categories = []
tags       = []
+++

Your email address is one of the most important aspects of your online
experience. You use it to communicate with others, receive newsletters, and
log in to various websites. However, you most likely don't own the domain for
your email address and I believe you should reconsider that and own your email
domain.

## What's an email domain?

Simple! It's the part of your email address that comes after the `@` symbol.
For example, given the email address `matthew@example.com` the email domain
is `example.com`.

## Who owns my email domain?

Your email provider owns your email domain. That is, unless you've configured
your email provider to use your own email domain in which case you aren't the
target audience for this post.

Here's a table of common email providers and their respective email domains.

| Email Provider | Email Domain     |
| -------------- | ---------------- |
| Gmail          | `gmail.com`      |
| iCloud         | `icloud.com`     |
| Yahoo          | `yahoo.com`      |
| Outlook        | `outlook.com`    |
| Proton Mail    | `protonmail.com` |

## Why should I own my email domain?

You should own your email domain for disaster recovery purposes and, if you're
using an email for business, branding and marketing purposes. I know the average
person doesn't normally think about disaster recovery but let me remind you just
how critical email is with a simple question.

What other accounts would you lose access to if you could no longer access your
email?

Email is tightly integrated with authentication to various accounts. Financial
accounts, social accounts, and other miscellaneous accounts all use your email
address in the following ways.

- To reset your password when it's forgotten.

- To send you a magic link to log in.

- To send you a verification code to log in.

- To sign you in via OAuth by redirecting you to a third-party account to log
in with your email address. For the "well, actually" crowd that's reading this,
yes, good OAuth implementations should allow for email address changes but there
are bad implementations out there that will create a separate account if you
change your email address and then log in via OAuth.

Say you're using Gmail or iCloud as your email provider. Will your email still
work when Gmail or iCloud shuts down? I know it's highly unlikely that Gmail
or iCloud will ever shut down. Even if they did there are too many people
using them for email that some entity will likely have to take over email
functionality. Still, it's a risk.

Let's look at a more realistic example. Your Gmail and iCloud email is tied to
your Google account or Apple ID respectively. That means violating the Google
or Apple terms of service can lead to your account being banned or deactivated
which means losing access to your email. It doesn't even have to be a malicious
action either. Perhaps you uploaded a video to YouTube that broke some arbitrary
rule or tried to skirt around Apple's tough App Store guidelines and received
an automatic ban by some bot. In the best case you're without email access for
a few hours or days. In the worst case you no longer have access to that email
address ever again.

If this happens you can't even take your email address to another email provider
since you don't own the domain. Instead you're forced to create another email
account and reach out the accounts you lost access to and beg support to update
the email address so you can log back in. Good luck with that! If you owned
your email domain you could have taken that domain to another email provider and
continued sending and receiving email.

If you're using your email address for business this same risk still applies.
Do you want to notify your customers that your email address changed because
you no longer have access to the previous one? Owning your email domain means
your business website domain can be the same as your business email domain. No
more `foocompany@gmail.com`. Instead you can have `contact@foocompany.com` or
whatever name you desire. This builds trust with your customers and allows you
to move email providers as your business scales without changing your email
domain. Plus, if you can't be bothered to spend money on your email domain for
your business why should customers bother spending money with your business?

## How do I own my email domain?

Owning your email domain **will cost you money** via initial registration fees
and annual renewal fees for the domain and monthly subscription fees for the
email provider. This is the cost to owning your email domain and not having your
data mined to use a "free" email provider.

Here's the process to own your own email domain.

1. Register a domain (e.g., `example.com`) with a domain registrar (e.g.,
[Porkbun](https://porkbun.com/)). This usually costs an initial registration fee
plus an annual renewal fee.

1. Choose an email provider that supports custom email domains (e.g., [Google
Workspace](https://workspace.google.com/), [Proton Mail](https://proton.me/),
[iCloud Mail](https://support.apple.com/en-in/102540)) and sign up for their
service. This usually costs a monthy subscription fee.

1. Configure the email provider to use your custom email domain. This is usually
done by going to the DNS provider for your email domain, which is your domain
registrar by default, and adding the DNS records that your email provider tells
you to add. Usually, you'll add the following types of DNS records.

    1. `MX` - Specifies the mail server(s) responsible for accepting email for
    your domain. `SRV` records can also be used for this per
    [RFC 6186](https://www.rfc-editor.org/rfc/rfc6186) but it's not common.

    1. `TXT`, `CNAME` - Used for domain verification and advanced
    email features like DKIM, SPF, and DMARC.

1. Log into your email provider and test sending and receiving email via your
custom email domain.

For reference, here are the DNS records my email provider Proton Mail asked me
to create in order to use `matthewsanabria.dev` as a custom email domain.

```sh
# MX records.
> dig +short -t MX matthewsanabria.dev
10 mail.protonmail.ch.
20 mailsec.protonmail.ch.

# TXT records for domain verification and SPF.
> dig +short -t TXT matthewsanabria.dev
"protonmail-verification=fa33422884d6fb9b9ca055b36c0331d776f7c81b"
"v=spf1 include:_spf.protonmail.ch ~all"

# TXT record for DMARC.
> dig +short -t TXT _dmarc.matthewsanabria.dev
"v=DMARC1; p=quarantine"

# CNAME records for DKIM.
> dig +short -t CNAME \
  protonmail._domainkey.matthewsanabria.dev \
  protonmail2._domainkey.matthewsanabria.dev \
  protonmail3._domainkey.matthewsanabria.dev
protonmail.domainkey.dr2r5cad2tpxcph27dvyoyxthh5mud6cdmi3yfvrtgltkvlj7vdwq.domains.proton.ch.
protonmail2.domainkey.dr2r5cad2tpxcph27dvyoyxthh5mud6cdmi3yfvrtgltkvlj7vdwq.domains.proton.ch.
protonmail3.domainkey.dr2r5cad2tpxcph27dvyoyxthh5mud6cdmi3yfvrtgltkvlj7vdwq.domains.proton.ch.
```

## Conclusion

There's not much else to say. Go out there and own your email domain!
