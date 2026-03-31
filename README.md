<!-- # Oh My Co-Researcher -->

![logo](assets/logo.png)

An extensible, self-improving Claude Code skill pack for autonomous ML research. Like oh-my-zsh but for research agents — start with the core five skills, then use `evolve` to personalize the pack to your workflow.

## Install

```bash
git clone <repo-url> oh-my-coresearcher
cd oh-my-coresearcher
./install.sh          # project-local
./install.sh --global # or into ~/.claude/skills
```

## Dependencies

### ARIS skill pack (required)

oh-my-coresearcher delegates to skills from [ARIS](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep):

```bash
curl -fsSL https://feynman.is/install-skills | bash -s -- --repo
```

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

### Feynman skill pack (optional, recommended)

Adds paper Q&A and reproducibility auditing via [Feynman](https://github.com/getcompanion-ai/feynman):

```bash
curl -fsSL https://feynman.is/install-skills | bash
```

| Skill / Tool | Used by | Purpose |
|-------------|---------|---------|
| `alpha-research` | `research` | Deep paper Q&A and linked code repo discovery |
| `audit` | `research` | Compare paper claims against public codebase implementations |

**AlphaXiv CLI** — required by `alpha-research`. After installing Feynman:

```bash
feynman alpha login   # authenticate once
alpha search "<query>"         # semantic paper search
alpha ask "<question>" <id>    # Q&A on a specific paper
alpha fetch <arxiv-id>         # retrieve full paper
alpha repo <arxiv-id>          # find linked code repository
```

### MCP servers

`review` uses an external critic. Configure at least one:

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

## Core skills

| Skill | When to use |
|-------|-------------|
| `research` | Main agent. Reads RESEARCH.md, infers gaps, adjusts TODOs, delegates to the right skill, proactively asks before acting. |
| `experiment` | Runs ML experiments: isolated venv, time-budgeted, failure-handled. Supports BFS mode for autonomous design space search. |
| `review` | Adversarial critique with FATAL/MAJOR/MINOR severity. Falls back through Codex → llm → minimax. |
| `write` | Paper drafting grounded in RESEARCH.md results. Marks `[UNGROUNDED]` and `[UNVERIFIED]` inline. |
| `evolve` | Session-end lesson extraction **and** skill pack personalization. Proposes diffs — human merges only. |

## How the agent loop works

`research` reads your project state and figures out what to do next:

1. **Assess** — compares Goal vs Context to find gaps ("experiments done but no paper TODO")
2. **Propose** — adjusts the TODO list and waits for confirmation before acting
3. **Act** — picks the top TODO and delegates to the right skill from the full ecosystem
4. **Loop** — surfaces the result and asks "shall I continue?" or offers options

On any new session or context compaction, the agent reads `## Pipeline Status` in `RESEARCH.md` first and resumes in ~30 seconds.

## BFS Mode (opt-in)

Inspired by [karpathy/autoresearch](https://github.com/karpathy/autoresearch). Ask the agent to "explore the design space" or "autoresearch". It confirms:

- **Target file** — the single file it can modify (e.g., `train.py`)
- **Metric** — a verifiable scalar to optimize (e.g., minimize `val_bpb`)
- **Budget** — time per run (default 5 min) and max experiments

Then `experiment` runs autonomously: design hypothesis → commit → run → extract metric → keep or `git reset` → repeat. Every run logged to `results.tsv`. Summary table lands in `RESEARCH.md` Context when done.

Off by default — only activates when you explicitly ask.

## Personalizing the skill pack

`evolve` has two modes:

**Session mode** — run at session end. Extracts generalizable lessons from RESEARCH.md History and git log, proposes diffs to affected SKILL.md files.

**Personalize mode** — point it at any external skill or skill pack. It will:
1. Read the target and inventory your installed skills
2. Check compatibility (name conflicts, missing tools/MCP, behavioral conflicts)
3. Detect scope overlap and show you the delta vs what you already have
4. Interview you — asks all questions at once: what to replace/merge/skip, which dependencies you have, what you explicitly don't want
5. Propose a curated diff incorporating only what you confirmed

```bash
/evolve                                     # session mode
/evolve -- personalize feynman audit skill  # integrate one external skill
/evolve -- personalize ~/.claude/skills/    # audit your entire installed pack
```

Diffs land in `lessons/`. Apply when satisfied:

```bash
git apply lessons/YYYYMMDD-personalize-slug.diff
```

Skills are never auto-modified. Human merges only.

## Evolution loops

**Research loop**: `research` picks TODO → delegates → updates `RESEARCH.md` → proposes next step → repeats.

**Skill evolution loop**: `evolve` (session) → `lessons/` → human review → `git apply` → better skills next session.

**Personalization loop**: find a useful skill elsewhere → `evolve` (personalize) → curated diff → merge → your pack grows.
