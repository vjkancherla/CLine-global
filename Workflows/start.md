## Session Startup

1. Run: `rtk gain -q`
2. Read `memory-bank/activeContext.md` and `memory-bank/progress.md` in the current workspace.
3. If there is no memory-bank, ask me whether to initialise it. If I say yes, initialise it by invoking the workflow `/Users/vkancherla/Documents/Cline/Workflows/init-memory.md`
4. Graphify — if `graphify-out/graph.json` exists in this workspace, use the graph: query it before reading or grepping files. If it does not exist, say so once and offer to build it (code-only is free and takes seconds). See "Graphify" below.
5. IMPORTANT — Once confirmed, ensure that from now on `rtk` is religiously used for all future commands.
6. When running AWS or Git commands, always disable the interactive pager. See "Shell Commands: Disable Interactive Pagers" below.
7. Stop and wait for my task.

## Graphify

`graphify-out/graph.json` is the cheapest way into a codebase — a query returns a scoped
subgraph instead of whole files.

- **Query before you read.** `graphify query "…" --budget 800`, `graphify path "A" "B"`,
  `graphify explain "X"`, `graphify god-nodes`. Read files only when the graph cannot answer.
- **Update after code changes.** `graphify update .` — AST only, no API key, seconds. A
  stale graph is worse than none.
- **Never commit it.** `graphify-out/` is generated; keep it in `.gitignore`.
- **Setup, install and troubleshooting:** `/Users/vkancherla/Documents/Cline/Workflows/graphify.md`

The global skill at `~/.cline/skills/graphify/SKILL.md` covers the same ground but loads
only when a task matches its description. This section is the always-on rule.

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