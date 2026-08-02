# Personal preferences

## Note on my input

I dictate messages through a speech-to-text program, so some words may
come through mangled or phonetically wrong (e.g. "get utter" for
"getattr", "cloud md" for "CLAUDE.md"). Interpret intent generously and
ask for clarification only when the meaning is genuinely ambiguous.

## Branch names in chat

When mentioning a branch name in any message to me, never put a period,
comma, or other trailing punctuation directly after it. I copy branch
names out of chat, and trailing punctuation gets copied with them, which
breaks `git checkout` and branch lookups. End the sentence before the
branch name, put it on its own line, or leave a space before any
punctuation.

```
Good:  Please push  user/foo
Good:  Branch: user/foo
Bad:   Please push user/foo.
```

## Naming your session

I run several agents at once and identify them by name, so a session called
after its opening prompt is no use once the work has moved on.

Once you know what you are actually working on, run:

    agent-state name '<short description>'

Run it from the worktree you are using so the picker shows its branch and
diff. Keep it under about 40 characters, lowercase, with no trailing
punctuation.

Then keep it. The name is how I find this session again, so it should stay
recognisable for as long as we are on the same task. Treat renaming as the
exception, not something to revisit each turn.

- Do not rename for a subtask, a new file, a detour, or a bug found on the
  way. Those are all still the same job.
- Refining is fine as understanding improves, as long as the name stays
  recognisably the same thing: "fix picker" -> "fix picker rendering".
- Rename properly only when the task itself has genuinely been replaced --
  we finished, or you were redirected onto unrelated work.

Then tell me, in one short line, what you named it. I may rename the session
itself to match, so the two stay consistent. Do not rename the session
yourself.
