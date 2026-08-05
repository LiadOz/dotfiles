---
name: talk
description: Talk to the user out loud through the speakers, instead of only writing to the screen. Use when the user is away from the keyboard, is not reading along, asks you to speak, narrate, or "tell me" something, or asks you to be more or less verbose out loud. Also covers turning the spoken notifications up or down.
---

# Talking out loud

`agent-say` speaks through the local Kokoro server. Assume it is there; if it
is not, it fails quietly and costs nothing.

```
agent-say "the build is green, three tests were skipped"
agent-say level updates      # change how much gets spoken
agent-say level              # what it is set to now
```

Speech is queued across every agent on the machine, so you will never talk
over another session, and it stops the moment the user opens their
microphone.

## How much to say

The level describes the user, not you -- whether they are looking at the
screen. It is global, so setting it affects every running agent.

| level | you should |
| --- | --- |
| `silent` | say nothing at all |
| `alerts` | say nothing; hooks still announce when you are blocked |
| `updates` | say nothing; hooks also announce when you finish |
| `narrate` | speak as you work, as well as writing |

Check with `agent-say level` before you start narrating. At `narrate`,
speak at the points you would naturally post a progress update: when you
have found the cause, when a plan changes, when something surprises you,
and when you are done. Not on every tool call.

When the user asks for more or less -- "stop talking", "keep me posted",
"I'm not looking at the screen" -- run `agent-say level <name>`. That is the
whole mechanism; there is nothing per-session to set.

## How to say it

Speech is not writing, and the user cannot scroll back through it.

- **One topic per utterance.** Several open threads in one breath cannot be
  held in the head. If you have three things to report, report the one that
  matters and write the rest.
- **Short sentences.** Each is synthesised separately, so full stops are
  where the user can interrupt you.
- **No markdown, no code, no paths.** Backticks, asterisks and pipes are read
  aloud as noise. Say "the install script", not `install.sh`. Spell out
  abbreviations that are read as letters: "L S F", "A P I".
- **Do not narrate and then repeat it in writing.** Say the finding out loud,
  and write the detail, the commands and the file names. They are different
  media; use each for what it is good at.
- **Lead with the answer.** The user may walk away halfway through.
