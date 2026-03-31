# oh-my-coresearcher

## Ground Truth

`RESEARCH.md` in the project root is the ground truth for project state.

- Read it at session start.
- Write back after each major action.
- Prefer asking the user over guessing when state is ambiguous.

## Session Recovery

On new session or after context compaction:
1. Read `RESEARCH.md` **Pipeline Status** section first (30-second orient).
2. Resume from **Active TODO** — do not restart from scratch.

## Skills

Skills in `skills/` are invoked by name:

- `research` — main orchestrator, picks next TODO
- `experiment` — runs ML experiments
- `review` — adversarial critique
- `write` — paper drafting
- `evolve` — extracts lessons and personalizes the skill pack

## Invocation Graph

- `research` → `experiment` / `run-experiment`, `write` / `paper-write`, `review` / `auto-review-loop`, `research-lit` / `arxiv`, `research-refine`, `experiment-plan`, `result-to-claim`, `paper-figure`, `evolve`
- `write` → auto-invokes `review` after each draft
- `review` → critic must run in isolated context (subagent, Codex MCP, or external API); falls back through `auto-review-loop-llm` → `auto-review-loop-minimax`
- `evolve` → reads only; no delegation

## Templates

Templates in `templates/` are copied to project root on init:

- `RESEARCH.md.template` → `RESEARCH.md` (living doc)
- `LESSON.md.template` → `lessons/YYYYMMDD-slug.md` (per-session)