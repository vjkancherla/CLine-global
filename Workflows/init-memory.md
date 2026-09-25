# Initialise Memory Bank

Scaffold and populate `memory-bank/` for this project.

## 1. Scaffold

Run:

```
bash ~/Documents/Cline/Scripts/init-memory-bank.sh .
```

The script is idempotent — it never overwrites an existing file. Read its output: it lists what was created, the detected stack, and every remaining `TODO` marker. Those markers are the work list for this workflow.

If it reports nothing was created, the memory bank already exists. Stop and say so — do not re-initialise.

## 2. Graphify

Do this before Inferring below — the graph makes section 3 cheaper.

Build the knowledge graph so later sessions query the codebase instead of reading it:

    graphify extract . --code-only
    graphify cluster-only . --no-label --no-viz

Code is parsed locally — no model, no API key, seconds. Docs, YAML, papers and images are
prose and need a backend; add them now if the machine has one, otherwise later:

    OPENAI_BASE_URL=http://127.0.0.1:8050/v1 OPENAI_MODEL=local-model OPENAI_API_KEY=local \
      graphify extract . --backend openai --max-concurrency 1 --token-budget 8000

Then keep it out of git. It is generated, and ignoring it also keeps the graph out of its
own scan, since `graph.json` is `.json`, which graphify classifies as code:

    graphify-out/

Skip this section entirely if `graphify-out/graph.json` already exists — do not rebuild a
graph that is already there. Full command reference, local-model settings and
troubleshooting: `/Users/vkancherla/Documents/Cline/Workflows/graphify.md`.

## 3. Infer

Fill only what the codebase and git history actually support. Look at:

- `README.md` — purpose and usage
- The dependency manifest — stack and non-obvious dependencies
- Directory layout and entry points — architecture
- `git log --oneline -30` — recent direction and current state
- CI config — the real build and test commands

Verify any command before writing it into `techContext.md`. A command that has not been run is a guess, and this file is what later sessions rely on to check their own work.

## 4. Ask

Stop and ask the user for anything not derivable from the code. At minimum:

- **Out of scope** — what this deliberately does not do
- **Success criteria** — how to tell it is done
- **Constraints** — target platform, performance or resource limits
- **Do not touch** — generated, vendored, or tool-managed paths

Ask these as one short numbered list, with your best guess against each so the user can correct rather than compose. Do not invent answers. Leave a heading as `TODO` rather than filling it with a plausible guess — a wrong brief propagates into every later session.

## 5. Verify

- [ ] No `TODO` markers left outside `docs/decisions/0000-template.md`
- [ ] `graphify-out/` is in `.gitignore`, and `graphify-out/graph.json` exists — or its absence is stated explicitly
- [ ] Every command in `techContext.md` has been run successfully
- [ ] `activeContext.md` and `progress.md` under 40 lines
- [ ] `projectbrief.md` and `productContext.md` under 40 lines
- [ ] `techContext.md` and `systemPatterns.md` under 60 lines
- [ ] Nothing duplicated between files
- [ ] Every `Updated` date is today

Report the line count of each file and any heading left as `TODO`.
