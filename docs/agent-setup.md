# oh-my-coresearcher — Agent Setup

Follow these steps in order. Run each command, verify it succeeded before continuing.

---

## Step 1 — Install this pack

Preferred (skills.sh CLI):

```bash
npx skills add zy-ning/co-researcher --all
```

Manual fallback:

```bash
git clone <repo-url> oh-my-coresearcher
cd oh-my-coresearcher
./install.sh --global
```

Verify: `ls ~/.claude/skills/research/SKILL.md` exists.

---

## Step 2 — ARIS skill pack (required)

```bash
git clone https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep.git /tmp/aris
cp -r /tmp/aris/skills/* ~/.claude/skills/
rm -rf /tmp/aris
```

Verify: `ls ~/.claude/skills/research-lit/` and `~/.claude/skills/auto-review-loop/` both exist.

---

## Step 3 — Codex MCP (required for `review`)

```bash
npm install -g @openai/codex
claude mcp add codex -s user -- codex mcp-server
```

For model selection: run `codex setup` and set model to `gpt-5.4` when prompted.

Verify: `claude mcp list` shows `codex`.

If Codex is unavailable, `review` falls back to `auto-review-loop-llm` (set `LLM_API_BASE` and `LLM_API_KEY` env vars) or `auto-review-loop-minimax` (set `MINIMAX_API_KEY`).

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

## Step 6 — Start a project

```bash
cp ~/.claude/skills/research/../../templates/RESEARCH.md.template ./RESEARCH.md
# or from the cloned repo:
# cp oh-my-coresearcher/templates/RESEARCH.md.template ./RESEARCH.md
```

Edit `RESEARCH.md`: fill in `## Goal` with the research direction.

Then invoke the `research` skill to begin.

---

## Verification checklist

| Component | Check |
|-----------|-------|
| Core skills | `ls ~/.claude/skills/research/SKILL.md` |
| ARIS skills | `ls ~/.claude/skills/research-lit/ ~/.claude/skills/auto-review-loop/` |
| Codex MCP | `claude mcp list \| grep codex` |
| Feynman (optional) | `ls ~/.claude/skills/alpha-research/` |
| LaTeX (optional) | `which latexmk` |
