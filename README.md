<!-- # Oh My Co-Researcher -->

![logo](assets/logo.png)

[中文](README_CN.md) | [English](README.md)

An extensible, self-improving Claude Code skill pack for autonomous ML research. Like oh-my-zsh but for research agents — five core skills, grow to fit your workflow.

> - **Markdown-only state.** `RESEARCH.md` is the single source of truth. No Python, no daemon. Any session resumes in 30 seconds.
> - **Inferring agent.** `research` spots gaps, adjusts the todo list, and asks before acting — not a fixed pipeline.
> - **Adversarial review.** Critic runs in an isolated context. Returns FATAL/MAJOR/MINOR issues + PROCEED/REFINE/PIVOT.
> - **BFS mode.** Opt-in autonomous design space search: hypothesize → commit → run → keep or `git reset` → repeat.
> - **Self-improving.** `evolve` proposes skill diffs from session lessons, or ingests external packs with compatibility checks. You merge.
> - **Compatible & Composable.** Use with any LLM agent framework. Pull in external skills from anywhere. Customize your stack.

---

## Installation and  Setup

Copy and paste this prompt to your LLM agent (Claude Code, Open Code, Codex, etc.):
```
Install and configure "oh-my-coresearcher" skill pack following the instructions in https://raw.githubusercontent.com/zy-ning/co-researcher/refs/heads/main/README.md and https://raw.githubusercontent.com/zy-ning/co-researcher/refs/heads/main/docs/agent-setup.md.
```

Quick install with skills.sh CLI:
```bash
npx skills add zy-ning/co-researcher --all
```

> **For agents** — fetch and follow [`docs/agent-setup.md`](docs/agent-setup.md) autonomously.
> **For humans** — follow the steps below.


### 1. Install this pack

Preferred (skills.sh):

```bash
npx skills add zy-ning/co-researcher --all
```

Manual fallback:

```bash
git clone <repo-url> oh-my-coresearcher
cd oh-my-coresearcher
./install.sh          # project-local (.claude/skills/)
./install.sh --global # or globally (~/.claude/skills/)
```

### 2. ARIS skill pack (required)

```bash
git clone https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep.git
cp -r Auto-claude-code-research-in-sleep/skills/* ~/.claude/skills/
```

Provides: `research-lit`, `arxiv`, `research-refine`, `experiment-plan`, `run-experiment`, `result-to-claim`, `paper-figure`, `paper-write`, `auto-review-loop`, `auto-review-loop-llm`, `auto-review-loop-minimax`.

### 3. Codex MCP (required for `review`)

```bash
npm install -g @openai/codex
codex setup                          # set model to gpt-5.4 when prompted
claude mcp add codex -s user -- codex mcp-server
```

Fallback: `auto-review-loop-llm` (set `LLM_API_BASE` + `LLM_API_KEY`) or `auto-review-loop-minimax` (set `MINIMAX_API_KEY`).

### 4. Feynman skill pack (optional)

```bash
curl -fsSL https://feynman.is/install-skills | bash
feynman alpha login   # authenticate AlphaXiv once
```

Provides: `alpha-research` (paper Q&A, `alpha ask/fetch/repo`), `audit` (paper-to-code reproducibility check).

### 5. LaTeX (optional, for PDF output)

```bash
brew install --cask mactex && brew install poppler        # macOS
sudo apt install texlive-full latexmk poppler-utils       # Ubuntu
```

### More skill packs

Use `evolve` (personalize mode) to selectively pull skills from any of these:

| Pack | What it adds |
|------|-------------|
| [ARIS](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep) | Core research pipeline (required above) |
| [Feynman](https://github.com/getcompanion-ai/feynman) | AlphaXiv paper Q&A, audit, deep research |
| [NanoResearch](https://github.com/OpenRaiser/NanoResearch) | 9-stage pipeline, SLURM/GPU orchestration, Feishu notifications |
| [AutoResearchClaw](https://github.com/aiming-lab/AutoResearchClaw) | 23-stage pipeline, anti-fabrication registry, self-healing experiment loop |

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
