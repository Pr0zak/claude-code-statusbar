# claude-code-statusbar

A minimal [Claude Code](https://docs.anthropic.com/en/docs/claude-code) status line that shows your working directory plus context window and rate-limit usage as compact progress bars.

```
~/myproject  [ ctx ███▌░ 72% ]  [ 5h ██▍░░ 48% 1h23m ]  [ 7d █░░░░ 21% ]
```

## What it shows

| Segment | Color | Source | Meaning |
|---------|-------|--------|---------|
| `cwd` | bold blue | `.cwd` | Current working directory |
| `[ ctx … % ]` | yellow | `.context_window.used_percentage` | Context window utilization |
| `[ 5h … % Xh Xm ]` | cyan | `.rate_limits.five_hour` | 5-hour rolling rate-limit usage + countdown to reset |
| `[ 7d … % ]` | green | `.rate_limits.seven_day` | 7-day rolling rate-limit usage |

Segments are only rendered when their underlying field is present in the statusLine JSON, so it stays clean if some data is missing.

The progress bars use Unicode partial-block characters (`░ ▏ ▎ ▍ ▌ ▋ ▊ ▉ █`) for ~2.5% precision in 5 columns.

## Install

```bash
mkdir -p ~/.claude
curl -fsSL https://raw.githubusercontent.com/Pr0zak/claude-code-statusbar/main/statusline-command.sh \
    -o ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

Then add the statusLine entry to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash /home/YOUR_USER/.claude/statusline-command.sh"
  }
}
```

Restart Claude Code to pick up the change. See the [statusLine docs](https://docs.anthropic.com/en/docs/claude-code/statusline) for details on the JSON Claude Code pipes in.

## Requirements

- `bash`
- `jq`

## License

MIT
