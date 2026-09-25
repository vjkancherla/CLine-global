# Graphify — Set Up and Use, Every Project

`graphify-out/graph.json` is the cheap path into a codebase: one query returns a scoped
subgraph instead of whole files. Code is parsed locally; only prose needs a model.

## 1. Install (once per machine)

graphify runs as a uv tool — `graphify` (CLI) plus an optional `graphify-mcp` server. All
three extras earn their place: without `terraform` every `.tf` file contributes nothing to
the graph, without `openai` no OpenAI-compatible backend is reachable, and `mcp` is the
optional server.

    uv tool install --force --python 3.12 "graphifyy[mcp,terraform,openai]"

The Cline skill is global, so every project sees it with no per-project setup:

    ~/.cline/skills/graphify/SKILL.md

## 2. Build the graph (once per project)

Code is tree-sitter AST plus a call-graph pass — local, no key, seconds:

    graphify extract . --code-only
    graphify cluster-only . --no-label --no-viz

Docs, YAML, papers and images are prose, so they need a model. Any OpenAI-compatible
server will do:

    OPENAI_BASE_URL=http://127.0.0.1:8050/v1 OPENAI_MODEL=local-model OPENAI_API_KEY=local \
      graphify extract . --backend openai --max-concurrency 1 --token-budget 8000

Three settings matter on a local model:

- `--max-concurrency 1` — a llama.cpp server launched with `-np 1` has one slot, so
  parallel calls only queue.
- `GRAPHIFY_MAX_OUTPUT_TOKENS=8192` — the default 32768 lets one dense chunk run to the
  cap. Measured: a single chunk generating 27,935 tokens and still going, ~20 minutes for
  one chunk of 24. Cap it or a corpus becomes an evening.
- `--token-budget 8000` — small chunks suit local models; 30000+ is for hosted models.

Result files are cached by content hash, so an interrupted run resumes and restarting
costs only the chunks in flight. Check progress without disturbing the server — a `GET`
never occupies the slot:

    curl -s http://127.0.0.1:8050/slots | python3 -c "import sys,json; s=json.load(sys.stdin)[0]; n=(s.get('next_token') or [{}])[0]; print(s.get('is_processing'), n.get('n_decoded'), n.get('n_remain'))"

## 3. Use it (every session)

    graphify query "how does X become Y" --budget 800   # BFS subgraph, budget-capped
    graphify query "…" --dfs --depth 4                  # trace one path
    graphify path "A" "B"                               # shortest path between concepts
    graphify explain "X"                                # one node and its neighbours
    graphify god-nodes --top 12                         # the architectural hubs
    graphify affected "X"                               # reverse traversal — what X touches

Query first, read files second. Escalate only when the graph cannot answer.

## 4. Keep it fresh

    graphify update .        # AST-only re-extract and merge — free, seconds

`graph.json` records `built_at_commit`; compare it with `git rev-parse HEAD` to detect a
stale graph. `graphify check-update .` is cron-safe. `graphify hook install` would
automate it with a post-commit hook, but it also writes git hooks and a merge driver —
do that only with explicit approval.

## 5. Commit hygiene

`graphify-out/` is generated (1.3M in a mid-size repo, about 65% of it cache). Ignore it:

    graphify-out/

Ignoring it also keeps the graph out of its own scan, because `graph.json` is `.json` and
graphify classifies `.json` as code. If a shareable artifact is wanted, commit
`GRAPH_REPORT.md` — small and diffable — not `graph.json`.

## 6. Troubleshooting

- **Every command warns the skill is stale** → refresh it: `graphify install --platform claude`,
  or replace `~/.cline/skills/graphify/SKILL.md`.
- **`graphify-mcp` dies with `symbol not found '_BIO_ADDR_free'`** → the uv tool's env has
  a broken `cryptography` wheel; reinstall the tool on a newer Python (3.12 works).
- **`.tf` files contribute nothing** → the `terraform` extra is missing.
- **One request runs for 20 minutes** → the output cap is too high for a local model; set
  `GRAPHIFY_MAX_OUTPUT_TOKENS`.
- **No nodes for docs** → prose needs a backend; a `--code-only` run never includes them.

## 7. What is not automatic

A Cline skill loads only when a task matches its description, so the skill alone does not
guarantee use. The guarantee is this workflow plus the `## Graphify` rule in `start.md`.
