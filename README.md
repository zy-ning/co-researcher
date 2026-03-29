# co-researcher

A Claude Code skill pack for autonomous AI research assistance. No Python, no CLI wrappers — just markdown skills, shell scripts, and templates.

## Install

```bash
git clone <repo-url> co-researcher
cd co-researcher
./install.sh
```

Use `./install.sh --global` to install into `~/.claude/skills` instead.

## Dependencies

co-researcher's orchestrator delegates to skills from the [ARIS skill pack](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep). Install it first (or ensure the following skills are available in your `~/.claude/skills/`):

| Skill | Used by | Purpose |
|-------|---------|---------|
| `research-lit` / `arxiv` | `research` | Literature survey |
| `research-refine` | `research` | Method / idea refinement |
| `experiment-plan` | `research` | Experiment blueprint |
| `run-experiment` | `research` | Remote / GPU experiment execution |
| `result-to-claim` | `research` | Validate what results actually support |
| `paper-figure` | `research` | Generate publication figures |
| `paper-write` | `research` | Full LaTeX paper drafting |
| `auto-review-loop` | `research`, `review` | Multi-round automated review |
| `auto-review-loop-llm` | `review` | Fallback reviewer (OpenAI-compatible) |
| `auto-review-loop-minimax` | `review` | Fallback reviewer (MiniMax) |

The five core skills (`experiment`, `write`, `review`, `evolve`, and `research` itself) work standalone — the above extend what `research` can delegate to.

### MCP servers

`review` uses an external critic model. Configure at least one:

| MCP server | Config key | Notes |
|------------|------------|-------|
| Codex MCP | `codex` | Preferred critic |
| llm-chat MCP | any OpenAI-compatible endpoint | Fallback via `auto-review-loop-llm` |
| MiniMax MCP | `minimax` | Fallback via `auto-review-loop-minimax` |

## Start a new project

```bash
cp templates/RESEARCH.md.template RESEARCH.md
```

Edit the Goal, then run `/research` to kick off.

## Skills

| Skill | When to use |
|-------|-------------|
| `research` | Main agent. Reads RESEARCH.md, infers gaps, adjusts TODOs, delegates to the right skill, and proactively asks before acting. |
| `experiment` | Runs ML experiments in isolated venvs with time budgets and failure handling. |
| `review` | Cross-model adversarial critique. Tries Codex → `auto-review-loop-llm` → `auto-review-loop-minimax` in order. |
| `write` | Paper drafting grounded in RESEARCH.md results. Marks `[UNGROUNDED]` and `[UNVERIFIED]` inline. |
| `evolve` | Session-end lesson extraction with propose-only diffs to SKILL.md files. |

## How the agent loop works

`research` is not a rigid pipeline — it's an agent that reads your project state and figures out what to do next:

1. **Assess** — compares Goal vs completed Context entries to find gaps ("experiments done but no paper TODO")
2. **Propose** — adjusts the TODO list and waits for your confirmation before acting
3. **Act** — picks the top TODO and delegates to the right skill from the full ecosystem
4. **Loop** — after each result, surfaces what it found and asks "shall I continue?" or offers options

On any new session or context compaction, the agent reads `## Pipeline Status` in `RESEARCH.md` first and resumes from where you left off.

## Evolution loops

**Research loop**: `research` picks a TODO → delegates to `experiment`/`write`/etc → updates `RESEARCH.md` → proposes next step → repeats.

**Skill evolution loop**: `evolve` runs at session end, extracts generalizable lessons, writes `lessons/YYYYMMDD-slug.md` files with proposed diffs to SKILL.md files. Human reviews and merges manually — no auto-editing skills.

## Updating skills

Proposed diffs land in `lessons/`. Review them, then:

```bash
git apply lessons/YYYYMMDD-slug.diff
# or edit SKILL.md directly
```

Skills are never auto-modified. Human merges only.
