---
title: "Take the System Initiative"
date: 2024-08-23T13:00:29-04:00
draft: true
series: []
tags: []
---

Infrastructure as code is dead. Don't believe me? Read on.

<!--more-->

Odds are you're familiar with infrastructure as code tools like Terraform,
OpenTofu, and Pulumi. Maybe you use these tools regularly and like them. Maybe
you have a love-hate relationship with them. Regardless, you feel _some_ way
about these tools. Have you ever stopped to wonder if there's something better?

Answer the following questions for yourself.

- How quickly can you deploy infrastructure as code changes?
- How easily can you modify the upstream source code?
- Can you list all of the inputs, outputs, and dependencies for a resource?
- Do you have a high-level view of all your deployed resources?

For most people, the answers to those questions aren't great. Let me answer
them for myself so you can see what I mean.

- How quickly can you deploy infrastructure as code changes?
  - However long it takes to get a code change reviewed and merged. Usually
  between minutes during working hours to hours or days otherwise.
- How easily can you modify the upstream source code?
  - Not that easy. I would have to fork the source code, modify it, build it,
  deploy it, and get it hooked up to the infrastructure as code tool. Would
  take more code reviews and possibly hours or days for the configuration.
- Can you list all of the inputs, outputs, and dependencies for a resource?
  - If everything is in the same code repository then probably with a good
  Language Server Protocol (LSP) configuration. Otherwise, I'll be using the
  documentation and good ole' `grep`.
- Do you have a high-level view of all your deployed resources?
  - Yes for those that are managed with some orchestration tool like Terraform
  Cloud, Spacelift, or Pulumi Cloud. Everything else would require reading
  state files or the like to build a graph of resources.

Sounds toilsome, doesn't it?

## It’s Time to Rebuild DevOps

In my opinion, much of the infrastructure as code pain comes from the fact that
the incumbent tools tightly couple themselves to a version control system. That
is, all of the toil that comes with version control systems is inherent in the
design of infrastructure as code. It's time to think about this differently.
It's time to rebuild DevOps. Thankfully, one company is doing just that- and
that company is [System Initiative][system-initiative].

System Initiative abandons infrastructure as code for infrastructure as models
and it's unlike anything I've worked with thus far. The interface is an
interactive architecture diagram that forms a graph whose nodes and edges are
powered by reactive, configurable functions. I know that sounds a bit like
techincal workplay so let me use more plain language. Imagine being able to
click on a resource in your architecture diagram, edit the code that manages
it, and view a dry-run of the results before deciding to apply those changes.
That's System Initiative, and its short feedback loop for managing resources is
_so_ refreshing compared to forking code and waiting for code review.

Here's what one of those architecture diagrams looks like on the System
Initiative canvas.

![The System Initiative canvas showing a diagram of Oxide computer resources.
There's a large green box containing 2 small yellow boxes representing SSH keys
and 1 red box representing a project that itself contains 3 small green boxes
representing compute instances.][system-initiative-oxide-diagram]

This canvas manages resources on an [Oxide][oxide] computer. Mind you, System
Initiative didn't ship with support for managing Oxide resources. I added that
support from scratch in about 30 minutes. More on that later.

Do you see the power yet?

## System Initiative Concepts

Before I show you how I added support for those Oxide resources let's talk
about the concepts in System Initiative. In System Initiative, you create an
asset when you want to manage a resource. Assets can have one or more functions
attached to them, and those functions can be one of the following types.

- **Action** - Performs an operation on an asset. Typically these are create,
read, update, and delete (CRUD) operations but can be customized to perform
_any_ operation (e.g., restart an instance).
- **Attribute** -  Sets a value for an attribute on the asset (e.g., name, ID).
Can be used to populate input and output sockets for use by other assets.
- **Authentication** - Configures authentication for an asset so that the asset
can communication with an upstream API.
- **Code Generation** - Converts information about an asset into other formats
(e.g., JSON, YAML) that can be used in other functions.
- **Qualification** - Validates information about an asset (e.g., valid
region). Used to block potentially dangerous operations.

When you place an asset on the canvas it can either be a component or a
configuration frame. Here's the general difference between the two.

- **Component** - Asset that manages a resource. Can have input and output
sockets connecting to and from other assets. Cannot contain nested assets.
- **Configuration Frame** - Asset that can contain nested assets. Any child
asset will automatically have its input sockets populated from the output
sockets of its parent. Can also manage a resource if desired.

Here's what components and configuration frames look like on the System
Initiative canvas.

![The System Initiative canvas showing a large green configuration frame box
that contains 3 small yellow component boxes
within.][system-initiative-asset-explanation]

This canvas has one `API Credential` configuration frame with three `SSH Public
Key` components nested within. The `API Credential` configuration frame has an
output socket named `API Credential` and the `SSH Public Key` components accept
an input socket named `API Credential`. Since the components are nested within
the configuration frame, the `API Credential` input sockets are automatically
populated from the output socket.

> A quick note on input and output sockets. Using the analogy of a function in
> programming, input sockets are like function arguments and output sockets are
> like function returns. I won't cover them much more in this post but that
> should be enough to build a better mental model.

## Developing Assets

Asset code:

```ts
function main() {
    const apiCredentialSecret = new SecretDefinitionBuilder()
        .setName("API Credential")
        .addProp(
            new PropBuilder()
            .setName("API Token")
            .setKind("string")
            .setWidget(
                new PropWidgetDefinitionBuilder()
                .setKind("password")
                .build()
            ).build())
        .addProp(
            new PropBuilder()
            .setName("Endpoint")
            .setKind("string")
            .setWidget(
                new PropWidgetDefinitionBuilder()
                .setKind("text")
                .build()
            ).build())
        .build();

    return new AssetBuilder()
        .defineSecret(apiCredentialSecret)
        .build();
}
```

Authentication code:

```ts
async function main(secret: Input): Promise < Output > {
    console.log("Configuring API Credential...")
    requestStorage.setEnv("OXIDE_TOKEN", secret["API Token"]);
    requestStorage.setEnv("OXIDE_HOST", secret["Endpoint"]);
}
```

Qualifications:

```ts
async function main(component: Input): Promise < Output > {
    const apiToken = requestStorage.getEnv("OXIDE_TOKEN");
    const host = requestStorage.getEnv("OXIDE_HOST");

    if ((!apiToken) && (!host)) {
        return {
            result: 'failure',
            message: 'Oxide API token and host must be set!'
        };
    }

    const apiURL = `${host}/v1/me`;

    const response = await fetch(apiURL, {
        method: "GET",
        headers: {
            "Authorization": `Bearer ${apiToken}`
        }
    });

    if (!response.ok) {
        const data = await response.text()

        return {
            result: 'failure',
            message: `HTTP error! Status: ${response.status}, Body: ${data}`
        };
    }

    return {
        result: 'success',
        message: 'API Credential qualified!'
    };
}
```

[oxide]: https://oxide.computer "Oxide Computer Company"
[system-initiative-asset-explanation]: https://cdn.matthewsanabria.dev/matthewsanabria.dev/system-initiative-asset-explanation.jpg "System Initiative Asset Explanation"
[system-initiative-oxide-diagram]: https://cdn.matthewsanabria.dev/matthewsanabria.dev/system-initiative-oxide-diagram.jpg "System Initiative Canvas - Oxide"
[system-initiative]: https://systeminit.com "System Initiative"
