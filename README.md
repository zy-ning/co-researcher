<!-- # Oh My Co-Researcher -->

![logo](assets/logo.png)

[中文](README_CN.md) | [English](README.md)

**Oh My Co-Researcher** is an extensible, self-improving Agent skill pack for autonomous ML research. Like oh-my-zsh but for research agents — start from a lean core and grow to fit your workflow.

A co-researcher, **fully yours**:

![illus](assets/illus.png)

> - **Autonomous but controllable.** Customize the supervision policy: when to ask, notify, or just do. Checkpoints, resource rules, idea-change rules — all configurable.
> - **Inferring agent.** `research` spots gaps, adjusts the todo list, and asks before acting — not a fixed pipeline.
> - **Adversarial review.** Critic runs in an isolated context. Returns FATAL/MAJOR/MINOR issues + PROCEED/REFINE/PIVOT.
> - **BFS mode.** Opt-in autonomous design space search in *autoresearch* style.
> - **Self-improving.** `evolve` proposes skill diffs from session lessons, or ingests external packs with compatibility checks. You merge.
> - **Compatible & Composable.** Use with any LLM agent framework. Pull in external skills from anywhere. Customize your stack.

---

## Installation and  Setup

Copy and paste this prompt to your LLM agent (Claude Code, Open Code, Codex, etc.):
```
Install and configure "Oh_My_Co-Researcher" skill pack following the instructions in https://raw.githubusercontent.com/zy-ning/Oh_My_Co-Researcher/refs/heads/main/README.md and https://raw.githubusercontent.com/zy-ning/Oh_My_Co-Researcher/refs/heads/main/docs/agent-setup.md.
```

> **For agents** — fetch and follow [`docs/agent-setup.md`](docs/agent-setup.md) autonomously.
> **For humans** — follow the steps below.


### 1. Install this pack

```bash
# Project-local (installs into current directory)
curl -fsSL https://raw.githubusercontent.com/zy-ning/Oh_My_Co-Researcher/main/install.sh | bash

# Global (skills available in any project)
curl -fsSL https://raw.githubusercontent.com/zy-ning/Oh_My_Co-Researcher/main/install.sh | bash -s -- --global
```

Installs: skills → `.claude/skills/`, templates → `templates/`, skillpacks → `skillpacks/`, `CLAUDE.md` → project root (or `~/.claude/co-researcher/` for global).

Alternative via skills.sh (skills only — no templates or CLAUDE.md):
```bash
npx skills add zy-ning/Oh_My_Co-Researcher
```

### 2. ARIS skill subset (recommended)

```bash
git clone https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep.git /tmp/aris
mkdir -p ~/.claude/skills
cp -r /tmp/aris/skills/research-lit ~/.claude/skills/
cp -r /tmp/aris/skills/research-refine ~/.claude/skills/
cp -r /tmp/aris/skills/experiment-plan ~/.claude/skills/
cp -r /tmp/aris/skills/result-to-claim ~/.claude/skills/
# Optional extras:
# cp -r /tmp/aris/skills/arxiv ~/.claude/skills/
# cp -r /tmp/aris/skills/paper-figure ~/.claude/skills/
rm -rf /tmp/aris
```

These are the ARIS skills this pack benefits from most:
- `research-lit` for literature survey
- `research-refine` for method and idea refinement
- `experiment-plan` for experiment blueprints
- `result-to-claim` for checking which conclusions the results actually support

Optional ARIS add-ons:
- `arxiv` if you want a second literature lookup surface
- `paper-figure` if you want ARIS figure-generation helpers

Skip by default: `run-experiment`, `paper-write`, and `auto-review-loop`. This pack already ships `experiment`, `write`, and `review`, so loading those ARIS replacements by default adds overlap more than value.

### 3. Codex MCP (optional, recommended external critic for `review`)

```bash
npm install -g @openai/codex
codex setup                          # set model to gpt-5.4 when prompted
claude mcp add codex -s user -- codex mcp-server
```

`review` prefers any isolated critic context. Use Codex MCP when you want an external boundary in Claude Code. Otherwise an isolated subagent can work too. Additional fallbacks: `auto-review-loop-llm` (set `LLM_API_BASE` + `LLM_API_KEY`) or `auto-review-loop-minimax` (set `MINIMAX_API_KEY`).

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
| [ARIS](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep) | Best source of research primitives to import selectively: lit survey, refinement, experiment planning, claim checking |
| [Feynman](https://github.com/getcompanion-ai/feynman) | Best optional add-on for AlphaXiv paper Q&A, audit, and cited research briefs |
| [NanoResearch](https://github.com/OpenRaiser/NanoResearch) | Alternative end-to-end backbone with 9 stages, SLURM/GPU orchestration, and notifications |
| [AutoResearchClaw](https://github.com/aiming-lab/AutoResearchClaw) | Heavyweight autonomous research system with multi-stage planning, guardrails, and self-healing loops |
| [AI-Research-SKILLs](https://github.com/Orchestra-Research/AI-Research-SKILLs) | Large capability library for specific ML tasks, infrastructure, and evaluation workflows |
| [academic-research-skills](https://github.com/Imbad0202/academic-research-skills) | Specialist pack for academic writing, review, and paper-production workflows |

## Skillpack registry

This repo now follows a **lean core + curated registry** model:

- built-in core skills stay the default base
- external packs are tracked in `skillpacks/skill_dictionary.yaml`
- curated bundles live in `skillpacks/presets/*.yaml`
- project-specific choices live in `.co-researcher/skills.yaml`

Use `customize` when you want the repo to recommend a stack instead of manually stitching many external skills together.

Typical flow:

1. choose a workflow profile (`core-only`, `literature-heavy`, `experiment-heavy`, `academic-rigor`, `balanced`, or custom)
2. choose dependency tolerance
3. choose autonomy style and resource policy
4. confirm a preset or custom stack
5. write `.co-researcher/skills.yaml`

See [`docs/skillpack-customization.md`](docs/skillpack-customization.md) for the registry model, config shape, and example project-local config.

## Start a new project

Run `/research` in your project directory. If `RESEARCH.md` is missing, the skill auto-downloads the template and `CLAUDE.md` from GitHub and prompts you to fill in the goal.

Manual fallback (if offline or installed via `install.sh`):

```bash
cp templates/RESEARCH.md.template RESEARCH.md  # project-local install
# or
cp ~/.claude/co-researcher/templates/RESEARCH.md.template RESEARCH.md  # global install
```

## Supervision control

Use `/supervision` to configure how much autonomy the agent should use for the current project.

The flow is preset-first, override-second:

1. choose a preset: `manual`, `checkpointed`, `autonomous`, or `wild`
2. adjust notification events if needed
3. adjust approval gates if needed
4. choose stop target / limits
5. configure resource rules
6. configure idea-change rules
7. save the policy into `RESEARCH.md` if you want it to persist

The policy lives in `RESEARCH.md` under `## Supervision Policy` so it stays human-readable and survives session recovery.

Key capabilities:

- queued approvals in `checkpointed` mode so the agent can continue unrelated allowed work
- resource classes for **Service / API**, **Compute**, and **Human / Physical** resources
- explicit control over whether idea improvements, strategy pivots, or compromises should notify or require approval
- optional `wild` mode for non-stop execution until completion criteria or a hard boundary is reached

Backward compatibility: if `## Supervision Policy` is absent, the current confirmation-first behavior remains unchanged.

For full details, see [`docs/supervision-system.md`](docs/supervision-system.md).

If you want to configure supervision together with preferred skillpacks and presets, use `customize` instead.

## Core skills

| Skill | When to use |
|-------|-------------|
| `research` | Main agent. Reads RESEARCH.md, infers gaps, adjusts TODOs, delegates to the right skill, and can follow a configurable supervision policy for notifications, approvals, stop targets, resource boundaries, and idea changes. |
| `experiment` | Runs ML experiments: isolated venv, time-budgeted, failure-handled. Supports BFS mode for autonomous design space search. |
| `review` | Adversarial critique with FATAL/MAJOR/MINOR severity. Falls back through Codex → llm → minimax. |
| `write` | Paper drafting grounded in RESEARCH.md results. Marks `[UNGROUNDED]` and `[UNVERIFIED]` inline. |
| `supervision` | Configures `## Supervision Policy` in `RESEARCH.md` through a preset-first flow. |
| `customize` | Project onboarding and personalization. Recommends presets/skillpacks from the curated registry and writes `.co-researcher/skills.yaml`. |
| `evolve` | Session-end lesson extraction **and** skill pack personalization. Proposes diffs — human merges only. |

## How the agent loop works

`research` reads your project state and figures out what to do next:

1. **Assess** — compares Goal vs Context to find gaps ("experiments done but no paper TODO")
2. **Propose** — adjusts the TODO list and waits for confirmation before acting
3. **Act** — picks the top TODO and delegates to the right skill from the full ecosystem
4. **Loop** — surfaces the result and asks "shall I continue?" or offers options

On any new session or context compaction, the agent reads `## Pipeline Status` in `RESEARCH.md` first and resumes in ~30 seconds.

If `RESEARCH.md` also includes `## Supervision Policy`, `research` uses it to decide whether to pause for approval, queue an approval and continue unrelated work, notify and continue, request bounded resources, or stop at a configured target. No policy section means the legacy behavior stays in place.

## BFS Mode (opt-in)

Inspired by [karpathy/autoresearch](https://github.com/karpathy/autoresearch). Ask the agent to "explore the design space" or "autoresearch". It confirms:

- **Target file** — the single file it can modify (e.g., `train.py`)
- **Metric** — a verifiable scalar to optimize (e.g., minimize `val_bpb`)
- **Budget** — time per run (default 5 min) and max experiments

Then `experiment` runs autonomously: design hypothesis → commit → run → extract metric → keep or `git reset` → repeat. Every run logged to `results.tsv`. Summary table lands in `RESEARCH.md` Context when done.

Off by default — only activates when you explicitly ask. Even under `wild`, BFS still respects explicit resource rules, safety boundaries, and completion criteria.

## Personalizing the skill pack

`evolve` has three modes:

**Session mode** — run at session end. Extracts generalizable lessons from RESEARCH.md History and git log, proposes diffs to affected SKILL.md files.

**Personalize mode** — point it at any external skill or skill pack. It will:
1. Read the target and inventory your installed skills
2. Check compatibility (name conflicts, missing tools/MCP, behavioral conflicts)
3. Detect scope overlap and show you the delta vs what you already have
4. Interview you — asks all questions at once: what to replace/merge/skip, which dependencies you have, what you explicitly don't want
5. Propose a curated diff incorporating only what you confirmed

**Registry mode** — refresh `skillpacks/skill_dictionary.yaml` and preset recommendations. It assesses external packs, records concise compatibility/necessity judgments, and keeps the shared registry decision-oriented.

When a substantial skill rewrite or new skill is needed, `evolve` requires an external `skill-creator` skill. If it is unavailable, `evolve` should stop and tell you instead of pretending the creation step succeeded.

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

**Registry loop**: assess a new pack or refresh an existing one → `evolve` (registry) → update `skillpacks/skill_dictionary.yaml` / presets → `customize` recommends better stacks next time.
