# Memory Bank

Project memory lives in `memory-bank/`. Two files load every task. Four load only when the work needs them. Context is scarce — read the minimum, write the minimum, keep both current.

If `memory-bank/` does not exist, do not create anything. Just move on.

## Session start

Read exactly these, in order, before anything else:

1. `memory-bank/activeContext.md`
2. `memory-bank/progress.md`
3. `git log --oneline -15`

Then state the current focus and the next action in one line, and begin. Read nothing else at this stage.

## Read on demand

Open these only when the current task requires it. Name the file and the reason first.

| File | Open when |
|---|---|
| `projectbrief.md` | Scope is unclear, or a request may fall outside it |
| `productContext.md` | Deciding user-facing behaviour or priority |
| `techContext.md` | Touching dependencies, build, config, or environment |
| `systemPatterns.md` | Changing architecture or adding a component |
| `docs/decisions/*.md` | Something above points at a specific ADR |
| `memory-bank/journal/*.md` | Investigating why a past choice was made. Grep first. One file. |

Never open these speculatively, and never more than one journal file at a time.

## Caps

| File | Max lines |
|---|---|
| activeContext.md | 40 |
| progress.md | 40 |
| projectbrief.md | 40 |
| productContext.md | 40 |
| techContext.md | 60 |
| systemPatterns.md | 60 |

## Writing

Update `activeContext.md` and `progress.md` when a task completes, when the approach changes, when the user says `update memory bank` or "wrap up", or before compacting context — not after.

On `update memory bank`, review all six files, but change only what is now wrong.

Overwrite these files. Do not append. Fill every heading; write `none` rather than removing one.

Before finishing, confirm:

- [ ] Both hot files under 40 lines
- [ ] Next Step names one concrete action, not a theme
- [ ] Every path mentioned exists
- [ ] Nothing duplicated from `git log` or another memory-bank file
- [ ] Updated date is today

## Overflow

At the cap, promote rather than trim:

- Decision plus rationale → new ADR in `docs/decisions/`, linked from `systemPatterns.md`
- A correction received twice → a rule in `.clinerules/`
- Narrative of what happened → append to `memory-bank/journal/YYYY-MM-DD.md`
- Anything recoverable from git or the code → delete it

Say what was promoted and where.

## Staleness

Where memory conflicts with the code, the code wins. Say so, correct the file, continue — never silently work around a stale entry.

If Updated is more than seven days old, treat the file as a hint and re-derive status from `git log` and the codebase.
