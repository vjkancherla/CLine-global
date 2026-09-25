# Review protocol

## Generating the review prompt

The review prompt is a **verbatim copy** of the text between the `=== BEGIN REVIEW
PROMPT ===` and `=== END REVIEW PROMPT ===` markers in
`docs/reviews/REVIEW-PROMPT-TEMPLATE.md`, with six substitutions: `[STEP]`, `[NN]`,
`[TOPIC]`, `[GOAL]`, `[COMMIT_RANGE]`, `[FILES]`.

- `[GOAL]` is copied word for word from the step in `docs/build-plan.md`. Not
  paraphrased, not shortened.
- `[FILES]` is the list of paths the step named as its scope.

Do **not** summarise, shorten, restructure or reword any question. Do **not** add an
account of what you did - the reviewer reads the design, not your story about it.

The generated file must contain all twelve numbered questions. If it does not, you did
it wrong.

## After generating it

Stop. Print:

> S<NN> checkpoint passed, committed as `<sha>`.
> Switch to a different model, start a fresh task, paste:
> `Read and follow docs/reviews/S<NN>-review-prompt.md`
> I will not start the next step until `S<NN>-findings.md` says CLEAR.

Do not begin the next step. Do not offer to.

## On findings

- **BLOCKED** - reopen the step, fix the blockers only, re-run the checkpoint,
  re-review. Tick nothing.
- **CONCERNS** - raise them with the human. Do not act unilaterally.
- **CLEAR** - the human ticks the review box, not you.

Never argue a blocker with the reviewer. If you think one is wrong, raise it with the
human as a design question.
