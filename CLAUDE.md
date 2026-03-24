# co-researcher

## Ground Truth

`RESEARCH.md` in the project root is the ground truth for project state.

- Read it at session start.
- Write back after each major action.
- Prefer asking the user over guessing when state is ambiguous.

## Skills

Skills in `skills/` are invoked by name:

- `research` — main orchestrator, picks next TODO
- `experiment` — runs ML experiments
- `review` — adversarial critique
- `write` — paper drafting
- `evolve` — extracts lessons

## Templates

Templates in `templates/` are copied to project root on init:

- `RESEARCH.md.template` → `RESEARCH.md` (living doc)
- `LESSON.md.template` → `lessons/YYYYMMDD-slug.md` (per-session)