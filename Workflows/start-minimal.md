## Session Startup

1. Run: `rtk gain -q`
2. IMPORTANT — Once confirmed, ensure that from now on `rtk` is religiously used for all future commands.
3. When running AWS or Git commands, always disable the interactive pager. See "Shell Commands: Disable Interactive Pagers" below.
4. Stop and wait for my task.

## Shell Commands: Disable Interactive Pagers

Interactive pagers (`less`, `more`) wait for keyboard input that an agent session
cannot provide. Any command that opens one hangs until it times out. Always
disable the pager for AWS and Git commands.

### Git

Use `--no-pager` (or `-P`), placed **before** the subcommand:

    rtk git --no-pager log --oneline -20
    rtk git --no-pager diff HEAD~1
    rtk git --no-pager branch -a
    rtk git --no-pager show <sha>

Affected subcommands include `log`, `diff`, `show`, `branch`, `tag`, `blame`,
`stash list`, and `shortlog`.

### AWS CLI

Use `--no-cli-pager` on every invocation:

    aws s3 ls --no-cli-pager
    aws ec2 describe-instances --no-cli-pager
    aws logs tail /aws/lambda/my-fn --no-cli-pager

### Do not confuse `--no-cli-pager` with `--no-paginate`

- `--no-cli-pager` — display only. Suppresses the pager; full results still returned. **Use this by default.**
- `--no-paginate` — API behaviour. Returns only the first page and stops. Use only when a single page is what you actually want; never as a blanket default, because it silently truncates results.

If a response may exceed one page and you need all of it, omit `--no-paginate`
and filter server-side instead (`--query`, `--max-items`, `--page-size`).

### Verification

If a command appears to hang with no output, the pager is the first thing to
check. Re-run with the appropriate flag before investigating anything else.