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
