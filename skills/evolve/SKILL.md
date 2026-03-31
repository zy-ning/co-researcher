---
name: evolve
description: >-
  Two modes. Session mode (default): extracts generalizable lessons from
  RESEARCH.md and git history at session end, proposes skill diffs — human
  merges. Personalize mode: reads an external skill or skill pack, checks
  compatibility and scope overlap against installed skills, interviews the user
  to understand what they want and what to skip, then proposes a curated diff.
  Never edits SKILL.md directly. Trigger phrases: "end session", "extract
  lessons", "personalize my skills", "integrate this skill", "update
  skillpack".
---

# Evolve

Two modes: **Session** (run at session end) and **Personalize** (integrate external skills). Never edit skill files directly.

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

5. If the lesson implies a skill change, write a unified diff under `## Proposed diff` and a matching `lessons/YYYYMMDD-<slug>.diff`.

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

Activate when the user says "personalize", "integrate this skill", or provides an external SKILL.md path or URL.

### Step 1 — Read external skill(s)

8. Read the target: a single SKILL.md, a skills directory, or a skill pack repo. Extract:
   - Name, description, trigger phrases
   - Tools, MCP servers, and external dependencies it references
   - Behavioral patterns (workflows, delegation, output files)

### Step 2 — Inventory installed skills

9. Read all SKILL.md files in `~/.claude/skills/` (or the project `.claude/skills/`). Build a map of:
   - Names and descriptions
   - Tools and MCP servers already in use
   - Overlapping trigger phrases

### Step 3 — Analyze

10. For each external skill, assess three dimensions:

    **Compatibility** — will it conflict?
    - Name collision with an installed skill?
    - References a tool/MCP not configured (e.g., `alpha login` not done)?
    - Contradicts a behavioral rule in an existing skill (e.g., different self-review policy)?

    **Scope overlap** — does it duplicate something?
    - Substantially the same as an installed skill → flag as overlap, note the delta
    - Partially overlapping → identify which parts are additive

    **New capability** — what does it genuinely add?
    - List capabilities not covered by any installed skill

### Step 4 — Interview the user

11. Ask targeted questions based on the analysis. Ask all at once, not one-by-one:

    For each **overlap** found:
    > "`<external>` overlaps with your `<installed>`. It differs in: `<delta>`. Replace, merge, or skip?"

    For each **missing dependency**:
    > "`<external>` requires `<tool/MCP>`. Do you have it configured? If not, should I skip the parts that need it?"

    For each **behavioral conflict**:
    > "`<external>` does `<X>` but your `<installed>` does `<Y>`. Which do you prefer?"

    Open question at the end:
    > "Is there anything from this skill you explicitly don't want?"

### Step 5 — Propose curated diff

12. Based on user answers, generate a diff that:
    - Incorporates only the confirmed additions
    - Skips the parts the user rejected or that have unresolved dependencies
    - Preserves existing behavior unless the user explicitly chose to replace it

13. Write the diff to `lessons/YYYYMMDD-personalize-<slug>.diff` with a companion `.md` documenting what was included, what was skipped, and why.

14. Tell the user: *"Diff ready at `lessons/YYYYMMDD-personalize-<slug>.diff`. Review and apply with `git apply` when satisfied."*

---

## Constraints

- Never write directly to any `SKILL.md` file. Always propose. The human merges.
- Create `lessons/` if it does not exist.
- In Personalize mode, err toward asking rather than assuming. One unanswered question is worth more than a wrong assumption baked into a diff.

## Example

**Session mode**: Session with 4 TODOs; 1 experiment failed due to unset random seed → `lessons/20260329-seed-reproducibility.diff`.

**Personalize mode**: User says "integrate Feynman's audit skill" → reads `audit/SKILL.md`, detects no name conflict, notes it requires no extra MCP, finds no overlap with existing skills → asks "Do you want the paper-code gap detection only, or also the replication plan?" → proposes targeted diff adding `audit` to the `research` delegation table and creating `skills/audit/SKILL.md`.
