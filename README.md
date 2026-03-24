# co-researcher

A Claude Code skill pack for autonomous AI research assistance. No Python, no CLI wrappers — just markdown skills, shell scripts, and templates.

## Install

```bash
git clone <repo-url> co-researcher
cd co-researcher
./install.sh
```

Use `./install.sh --global` to install into `~/.claude/skills` instead.

## Start a new project

```bash
cp templates/RESEARCH.md.template RESEARCH.md
```

Edit the Goal, then run `research` to kick off.

## Skills

| Skill | When to use |
|-------|-------------|
| `research` | Main orchestrator. Reads TODOs, decides BFS/DFS, coordinates other skills. |
| `experiment` | Runs ML experiments in isolated venvs with time budgets and failure handling. |
| `review` | Cross-model adversarial critique via Codex MCP. Verifiable + subjective rubric. |
| `write` | Paper drafting with grounding and citation verification. |
| `evolve` | Session-end lesson extraction with propose-only diffs to SKILL.md files. |

## Evolution loops

**Research loop**: `research` picks a TODO → delegates to `experiment`/`write` → updates `RESEARCH.md` → repeats. Supports BFS (parallel branches for competing hypotheses) and DFS (deep dives with git stash checkpoints).

**Skill evolution loop**: `evolve` runs at session end, extracts generalizable lessons, writes `lessons/YYYYMMDD-slug.md` files with proposed diffs to SKILL.md files. Human reviews and merges manually — no auto-editing skills.

## Updating skills

Proposed diffs land in `lessons/`. Review them, then:

```bash
git apply lessons/YYYYMMDD-slug.diff
# or edit SKILL.md directly
```

Skills are never auto-modified. Human merges only.
