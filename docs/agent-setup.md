# Oh_My_Co-Researcher — Agent Setup

Follow these steps in order. Run each command, verify it succeeded before continuing.

---

## Step 1 — Install this pack

```bash
curl -fsSL https://raw.githubusercontent.com/zy-ning/Oh_My_Co-Researcher/main/install.sh | bash -s -- --global
```

This installs skills to `~/.claude/skills/`, templates to `~/.claude/co-researcher/templates/`, and `CLAUDE.md` to `~/.claude/co-researcher/`.

Verify: `ls ~/.claude/skills/research/SKILL.md` exists.

---

## Step 2 — ARIS skill subset (recommended)

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

These four skills cover the main gaps this pack delegates outward: literature survey, method refinement, experiment planning, and result-to-claim validation.

Verify: `ls ~/.claude/skills/research-lit/ ~/.claude/skills/research-refine/ ~/.claude/skills/experiment-plan/ ~/.claude/skills/result-to-claim/`

---

## Step 3 — Codex MCP (optional, recommended external critic for `review`)

```bash
npm install -g @openai/codex
claude mcp add codex -s user -- codex mcp-server
```

For model selection: run `codex setup` and set model to `gpt-5.4` when prompted.

Verify: `claude mcp list` shows `codex`.

`review` only requires an isolated critic context. Use Codex MCP when you want an external boundary in Claude Code. If Codex is unavailable, an isolated subagent is still valid, and additional fallbacks are `auto-review-loop-llm` (set `LLM_API_BASE` and `LLM_API_KEY` env vars) or `auto-review-loop-minimax` (set `MINIMAX_API_KEY`).

---

## Step 4 — Feynman skill pack (optional)

Skip if paper Q&A and reproducibility auditing are not needed.

```bash
curl -fsSL https://feynman.is/install-skills | bash
```

Verify: `ls ~/.claude/skills/alpha-research/` exists.

Authenticate AlphaXiv (requires account at alphaxiv.org):
```bash
feynman alpha login
```

---

## Step 5 — LaTeX (optional, required for PDF output)

Skip if `write` skill will only produce `paper.md`, not compiled PDF.

```bash
# macOS
brew install --cask mactex && brew install poppler

# Ubuntu/Debian
sudo apt install texlive-full latexmk poppler-utils
```

Verify: `which latexmk` returns a path.

---

## Step 6 — Skillpack registry and presets (optional, recommended)

This pack supports a curated registry and project-local customization model:

- project-local install registry: `skillpacks/skill_dictionary.yaml`
- global install registry: `~/.claude/co-researcher/skillpacks/skill_dictionary.yaml`
- preset bundles live alongside that registry in `skillpacks/presets/` or `~/.claude/co-researcher/skillpacks/presets/`
- project-local config: `.co-researcher/skills.yaml`

Recommended flow:

1. start with the built-in core
2. use `customize` to choose a preset or custom stack
3. let `evolve` refresh the shared registry when you want to assess new packs

Use `.co-researcher/skills.yaml` to record:

- enabled packs and selected skills
- preference knobs such as overlap/dependency tolerance
- supervision policy for the current project

See [`docs/skillpack-customization.md`](skillpack-customization.md) for the full model.

---

## Step 7 — Start a project

In your research project directory, invoke the `research` skill. If `RESEARCH.md` is missing, the skill will auto-download the template and `CLAUDE.md` from GitHub and prompt you to fill in `## Goal`.

Manual fallback (if offline):
```bash
cp ~/.claude/co-researcher/templates/RESEARCH.md.template ./RESEARCH.md
cp ~/.claude/co-researcher/CLAUDE.md ./CLAUDE.md
```

Then invoke the `research` skill to begin.

---

## Verification checklist

| Component | Check |
|-----------|-------|
| Core skills | `ls ~/.claude/skills/research/SKILL.md` |
| ARIS skills | `ls ~/.claude/skills/research-lit/ ~/.claude/skills/research-refine/ ~/.claude/skills/experiment-plan/ ~/.claude/skills/result-to-claim/` |
| Codex MCP | `claude mcp list \| grep codex` |
| Feynman (optional) | `ls ~/.claude/skills/alpha-research/` |
| Templates | `ls ~/.claude/co-researcher/templates/RESEARCH.md.template` |
| CLAUDE.md | `ls ~/.claude/co-researcher/CLAUDE.md` |
| LaTeX (optional) | `which latexmk` |
| Registry (project-local install) | `ls skillpacks/skill_dictionary.yaml skillpacks/presets/` |
| Registry (global install) | `ls ~/.claude/co-researcher/skillpacks/skill_dictionary.yaml ~/.claude/co-researcher/skillpacks/presets/` |
