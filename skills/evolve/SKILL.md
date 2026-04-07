---
name: evolve
description: >-
  Three modes. Session mode (default): extracts generalizable lessons from
  RESEARCH.md and git history at session end; lessons that imply a new or
  significantly changed skill are handed off to skill-creator. Personalize
  mode: searches the skills registry via `npx skills find`, reads the target
  skill(s), checks compatibility and scope overlap against installed skills,
  interviews the user to understand what they want and what to skip, then
  creates or improves skills using skill-creator. Registry mode: curates
  `skillpacks/skill_dictionary.yaml` and `skillpacks/presets/*.yaml` by assessing external
  packs, judging necessity/compatibility, and recommending subsets. Create
  mode: designs a brand-
  new skill from scratch using skill-creator. Never edits SKILL.md directly —
  all changes go through skill-creator's draft→test→iterate loop, human merges.
  Trigger phrases: "end session", "extract lessons", "personalize my skills",
  "integrate this skill", "update skillpack", "find a skill for", "create a
  skill", "improve skill", "refresh the skillpack registry", "assess this skill
  pack", "update skill_dictionary.yaml", "update index.yaml".
---

# Evolve

Four modes: **Session** (run at session end), **Personalize** (discover and integrate external skills), **Registry** (curate `skillpacks/skill_dictionary.yaml` and presets), **Create** (build a new skill from scratch). Skill creation and significant rewrites always go through `skill-creator` — never write to SKILL.md directly.

If `skill-creator` is unavailable in the current environment, stop and tell the user. Do not silently simulate its workflow.

---

## Mode 1 — Session

### Inputs

1. Read `RESEARCH.md` **History** section and the git log (`git log --since="24 hours ago" --oneline`).

### Identify Candidate Lessons

2. Look for: things that failed and why; unexpected experiment results; debugging insights that took significant effort; workflow improvements; decisions that were revisited or reversed.

### Generalize Filter

3. For each candidate: *"Would this help in a different project on a different topic?"*
   - **No** → discard. Project-specific learnings stay in `RESEARCH.md`.
   - **Yes** → write a lesson file.

### Write Lesson Files

4. Create `lessons/YYYYMMDD-<slug>.md` using `LESSON.md.template`. Fill in: Trigger, Lesson, Evidence, Applies to, Confidence (LOW/MED/HIGH), Status (PROPOSED).

5. If the lesson implies a skill change, classify it:
   - **Minor tweak** (wording, one extra step, edge case) → write a unified diff under `## Proposed diff` and a matching `lessons/YYYYMMDD-<slug>.diff`.
   - **New skill or significant rewrite** → hand off to `skill-creator`: describe the intent, provide the lesson as context, and follow its draft→test→iterate loop. The resulting SKILL.md lands in `lessons/` as a proposal — never installed directly.

### Session Summary

6. Print:
   ```
   Session summary:
   - TODOs completed: N
   - Key metrics: <any that moved>
   - Lessons extracted: N
   - Skill diffs proposed: N
   ```
7. Tell the user: *"Review proposed diffs in `lessons/`. Merge with `git apply` or edit directly."*

---

## Mode 2 — Personalize

Activate when the user says "personalize", "integrate this skill", "find a skill for", or provides an external SKILL.md path or URL.

### Step 0 — Discover (if no target provided)

8. If the user gives a description rather than a path/URL, search the registry:
   ```bash
   npx skills find "<query>"
   ```
   Present the top results (name, description, install command) and ask the user which to integrate. Then continue with the chosen skill(s).

### Step 1 — Read external skill(s)

9. Read the target: a single SKILL.md, a skills directory, or a skill pack repo. Extract:
   - Name, description, trigger phrases
   - Tools, MCP servers, and external dependencies it references
   - Behavioral patterns (workflows, delegation, output files)

### Step 2 — Inventory installed skills

10. Read all SKILL.md files in `~/.claude/skills/` (or the project `.claude/skills/`). Build a map of:
    - Names and descriptions
    - Tools and MCP servers already in use
    - Overlapping trigger phrases

### Step 3 — Analyze

11. For each external skill, assess three dimensions:

    **Compatibility** — will it conflict?
    - Name collision with an installed skill?
    - References a tool/MCP not configured (e.g., `alpha login` not done)?
    - Contradicts a behavioral rule in an existing skill?

    **Scope overlap** — does it duplicate something?
    - Substantially the same as an installed skill → flag as overlap, note the delta
    - Partially overlapping → identify which parts are additive

    **New capability** — what does it genuinely add?
    - List capabilities not covered by any installed skill

### Step 4 — Interview the user

12. Ask targeted questions based on the analysis. Ask all at once, not one-by-one:

    For each **overlap**: > "`<external>` overlaps with your `<installed>`. It differs in: `<delta>`. Replace, merge, or skip?"

    For each **missing dependency**: > "`<external>` requires `<tool/MCP>`. Do you have it? If not, skip those parts?"

    For each **behavioral conflict**: > "`<external>` does `<X>` but your `<installed>` does `<Y>`. Which do you prefer?"

    Open: > "Anything from this skill you explicitly don't want?"

### Step 5 — Create or improve via skill-creator

13. Based on user answers, determine the scope:
    - **Additive merge** (minor additions to an existing skill) → write a unified diff to `lessons/YYYYMMDD-personalize-<slug>.diff` with a companion `.md`.
    - **New skill or substantial rewrite** → hand off to `skill-creator`: describe the desired skill, provide the source material and user's confirmed preferences as context, and follow its draft→test→iterate loop. Output lands in `lessons/` as a proposal.

14. Tell the user: *"Ready in `lessons/`. Review and apply with `git apply` when satisfied."*

---

## Mode 3 — Registry

Activate when the user asks to refresh the tracked skill-pack catalog, assess a new pack, compare packs, or update `skillpacks/skill_dictionary.yaml` / preset definitions.

### Registry inputs

Read:

- `skillpacks/skill_dictionary.yaml`
- `skillpacks/presets/*.yaml`
- `README.md` / `README_CN.md` pack comparison sections when relevant

If the user points at a new external repo, read its README and any obvious skill inventory files first.

### Responsibilities

15. Maintain `skillpacks/skill_dictionary.yaml` as the shared curated registry.

16. For each pack or skill being assessed, judge:
    - **workflow fit**
    - **gap coverage**
    - **overlap cost**
    - **dependency burden**
    - **maintenance health**
    - **composability**
    - **supervision sensitivity**
    - **autonomy bias**

17. Normalize outputs into concise labels when possible:
    - necessity: `default | recommended | optional | niche | avoid`
    - compatibility: `high | medium | low`
    - role: `base | donor | overlay | niche | experimental`

18. Recommend **subsets**, not bulk imports, unless the user clearly asks for a full-pack strategy.

19. Update presets when the registry change meaningfully affects default recommendations.

20. Keep rationales concise and decision-oriented. The registry is for recommendation and comparison, not exhaustive catalog dumps.

### Safety boundary

21. Registry curation may edit `skillpacks/skill_dictionary.yaml` and `skillpacks/presets/*.yaml`, but changes to existing `SKILL.md` behavior still require either:
    - a minor diff proposal in `lessons/`, or
    - a `skill-creator` handoff for substantial rewrites.

22. If a registry update would imply changing default project behavior materially, ask before proceeding.

---

## Mode 4 — Create

Activate when the user says "create a skill for X" or "build a new skill".

23. Capture intent: what should the skill do, when should it trigger, what's the expected output?
24. Check `npx skills find "<intent>"` — if a close match exists, suggest integrating it instead (Mode 2).
25. If creating from scratch, hand off to `skill-creator` with the captured intent. Follow its draft→test→iterate loop fully. Output lands in `lessons/` as a proposal.

---

## Constraints

- Never write directly to any `SKILL.md` file. Always propose. The human merges.
- Create `lessons/` if it does not exist.
- `skillpacks/skill_dictionary.yaml` and `skillpacks/presets/*.yaml` are curated repo metadata and may be updated directly in Registry mode when the user asks.
- All skill creation and significant rewrites go through `skill-creator`. Raw diffs are only for minor, targeted changes.
- Err toward asking rather than assuming. One unanswered question beats a wrong assumption baked into a diff.

## Example

**Session mode**: Experiment failed due to unset random seed. Minor → `lessons/20260329-seed-reproducibility.diff`. New workflow implied → hand off to `skill-creator` to draft a `reproducibility-check` skill.

**Personalize mode**: User says "find me a skill for LaTeX compilation" → `npx skills find "latex"` returns 3 results → user picks one → reads it, finds no conflicts → substantial enough to need skill-creator → draft→test→iterate → `lessons/20260401-personalize-latex.diff`.

**Create mode**: User says "create a skill for Slack notifications" → `npx skills find "slack"` finds a close match → suggests integrating it → user confirms → Mode 2 kicks in.
