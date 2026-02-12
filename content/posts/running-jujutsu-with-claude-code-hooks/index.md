+++
title       = "Running Jujutsu with Claude Code Hooks"
description = "Let's use Jujutsu with Claude Code hooks to never lose edits."
summary     = "Let's use Jujutsu with Claude Code hooks to never lose edits."
keywords    = ["AI", "Jujutsu", "jj", "hook"]
date        = "2025-06-30T23:00:00-04:00"
publishDate = "2025-06-30T23:00:00-04:00"
lastmod     = "2026-02-11T23:00:00-05:00"
draft       = false
aliases     = []
featureAlt  = "The Jujutsu logo and Claude Code logo with a heart in between."

# Taxonomies.
categories = []
tags       = []
+++

Anthropic released [Claude Code hooks](https://docs.anthropic.com/en/docs/claude-code/hooks)
which allow you to execute arbitrary commands at various points in Claude Code's lifecycle.

Let's see how we can use these hooks to run `jj` commands. Specifically, so we
never lose edits done by AI.

Hooks are triggered by different hook events.

* `PreToolUse`
* `PostToolUse`
* `Notification`
* `Stop`

Each hook event passes JSON data to your hook that can either be parsed and used
or ignored entirely. Additionally, Claude Code respects certain exit codes and data
received on standard output or standard error. You can read the documentation
for all those details. You're a professional.

## Creating a Hook

The simplest way to create a hook is to open `claude` and run `/hooks`. From
there you can follow the prompts to create a hook for a specific hook event. I
won't even show screenshots of this process since it's that straightforward. You
can also ask Claude Code how to make hooks for Claude Code if that's your
preferred level of inception.

Hook configuration is written in JSON. Create a JSON file in one of the following
locations with the configuration for your hook.

* `.claude/settings.local.json` - Project Settings (local)
* `.claude/settings.json` - Project Settings
* `~/.claude/settings.json` - User Settings

Here's the hook I created to run `jj commit` on Claude Code `Stop` hook events.

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "jj commit -m 'automatic commit'"
          }
        ]
      }
    ]
  }
}
```

This is pretty neat since every time Claude Code stops I get a nice commit
containing all the lovely edits Claude Code made on my behalf. A nice commit
that I can use to restore a previous working copy should Claude Code go off the
rails and make horrible edits.

## Custom Hooks

The `jj` hook above was pretty simple. Run `jj commit` on `Stop` hook events.
There's nothing dynamic about that hook. Let's change that.

Hooks receive input from Claude Code and can send output back to Claude Code.
That means I can write a custom hook that's more dynamic than just running `jj
commit`.

After about 5-10 minutes of using my human brain, here's what I wrote. Take
a moment to use your human brain to read and understand the code. It's quite
trivial since I was in discovery mode here to see how this all works.

```go
package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
)

// StopHookInput is the input that Claude Code sends during a Stop hook event.
type StopHookInput struct {
	SessionID      string `json:"session_id"`
	TranscriptPath string `json:"transcript_path"`
	StopHookActive bool   `json:"stop_hook_active"`
}

// TranscriptSummary is (not always?) the first line of JSON in the JSONL file
// from [StopHookInput.TranscriptPath].
type TranscriptSummary struct {
	Type     string `json:"type"`
	Summary  string `json:"summary"`
	LeafUUID string `json:"leafUuid"`
}

func main() {
	// Decode the hook input.
	var stopHookInput StopHookInput
	if err := json.NewDecoder(os.Stdin).Decode(&stopHookInput); err != nil {
		fmt.Fprintf(os.Stderr, "Error decoding StopHookInput: %v", err)
		os.Exit(2)
	}

	// Open the transcript file.
	transcriptFile, err := os.Open(stopHookInput.TranscriptPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error opening transcript file: %v", err)
		os.Exit(2)
	}

	// Read the first line of the transcript file assuming it's the transcript
	// summary.
	bufReader := bufio.NewReader(transcriptFile)
	transcriptBytes, err := bufReader.ReadBytes('\n')
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading first line of transcript: %v", err)
		os.Exit(2)
	}

	// Decode the transcript summary.
	var transcriptSummary TranscriptSummary
	if err := json.Unmarshal(transcriptBytes, &transcriptSummary); err != nil {
		fmt.Fprintf(os.Stderr, "Error decoding first line of transcript: %v", err)
		os.Exit(2)
	}

	// Build the commit message.
	commitMessage := fmt.Sprintf("claude(%s): automatic commit", stopHookInput.SessionID)
	if transcriptSummary.Summary != "" {
		commitMessage = fmt.Sprintf("%s\n\n%s", commitMessage, transcriptSummary.Summary)
	}

	// Run jj commit.
	cmd := exec.Command("jj", "commit", "--message", commitMessage)
	if err := cmd.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Error running jj commit: %v", err)
		os.Exit(2)
	}
}
```

The code parses the expected Claude Code input and uses that input to build a
commit message. Then it runs `jj commit` with that commit message. Since `jj`
automatically includes all changed files in the working copy in the commit, I
get a snapshot of all the file changes. Lovely!

Here's the updated JSON configuration for my hook. The only thing changed was
the command.

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "custom-claude-hook"
          }
        ]
      }
    ]
  }
}
```

After testing the hook for a bit here's what the last 5 commits looked like.

```sh
> jj log -r '@-----..@'
@  svylqsuy me@matthewsanabria.dev 2025-06-30 23:41:07 65083105
│  (empty) (no description set)
○  qyppskxx me@matthewsanabria.dev 2025-06-30 22:58:29 git_head() 6a110f32
│  claude(b9e98fa9-3a85-4573-a987-f4a82ec290ad): automatic commit
○  ttntoowr me@matthewsanabria.dev 2025-06-30 22:57:23 69ade10f
│  claude(02702b0f-4e59-4d44-bd41-6bc157f7924b): automatic commit
○  lskkpvww me@matthewsanabria.dev 2025-06-30 22:56:55 58af832a
│  claude(02702b0f-4e59-4d44-bd41-6bc157f7924b): automatic commit
○  lqkqqsol me@matthewsanabria.dev 2025-06-30 22:56:09 74c663e5
│  claude(02702b0f-4e59-4d44-bd41-6bc157f7924b): automatic commit
~
```

Pretty nice, if not a bit noisy.

### So Many Commits

I know. This approach is noisy. There are a ton of commits that can quickly add
up in a typical Claude Code session. Not to mention that this approach makes a
new commit even when no files have changed.

Can we do better?

[Graham Christensen](https://grahamc.com/) made me aware that `jj` does
automatic snapshotting of the working copy when running commands like `jj log`
or `jj show`.

That means we can greatly simplify our approach here and just run `jj show`
instead of `jj commit`. We don't even need a custom program!

> **Note**: A reader named Jason reached out to me noting that `jj show` can
contain large output that negatively impacts Claude. To work around this issue,
you can pipe the output of `jj show` and `jj log` to `/dev/null` or you can use
options that limit the command output (e.g., `jj show --summary`).

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "jj show --summary"
          }
        ]
      }
    ]
  }
}
```

Now, if we want to restore to a previous working copy we can just use `jj op
log` and `jj op restore`. A bit more atypical than how one normally works with
commits but much cleaner in your commit history.

Thanks Graham!

## I'm Hooked

I'm excited for Claude Code hooks. It's the missing link in making Claude Code
more customizable for users. I particularly like that Anthropic kept the
project (local), project, and user scopes for hooks so that they can be created
for different needs and even combined to form new functionality.

I'll likely create new hooks over time as I find more use cases that help me in
my workflow. I look forward to seeing what the community creates as well. Happy
coding!
