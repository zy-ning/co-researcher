---
name: evolve
description: Use at session end to extract generalizable lessons from RESEARCH.md and git history and propose skill diffs without editing skills directly.
---

# Evolve

Run at session end. Extract generalizable lessons and propose skill improvements. Never edit skill files directly.

## Inputs

1. Read `RESEARCH.md` **History** section and the git log for this session (`git log --since="today" --oneline` or similar).

## Identify Candidate Lessons

2. Look for:
   - Things that failed and why.
   - Unexpected experiment results.
   - Debugging insights that took significant effort.
   - Workflow improvements discovered during the session.
   - Decisions that were revisited or reversed.

## Generalize Filter

3. For each candidate, ask: *"Would this lesson help in a different project on a different topic?"*
   - **No** → discard it. Project-specific learnings stay in `RESEARCH.md`, not in lessons.
   - **Yes** → proceed to write a lesson file.

## Write Lesson Files

4. For each generalizable lesson, create a file at `lessons/YYYYMMDD-<slug>.md` using the `LESSON.md.template`. Fill in:
   - **Trigger** — the specific situation that caused the lesson.
   - **Lesson** — the generalizable rule, stated as an imperative.
   - **Evidence** — the concrete example from this session.
   - **Applies to** — which skill(s) this lesson affects (e.g., `experiment`, `research`).
   - **Confidence** — `LOW`, `MED`, or `HIGH` based on how reproducible the evidence is.
   - **Status** — always set to `PROPOSED`.

5. If the lesson implies a change to a skill file, write the proposed diff under **## Proposed diff** in the lesson file. Use unified diff format. Create a corresponding `.diff` file at `lessons/YYYYMMDD-<slug>.diff` that can be applied with `git apply`.

## Session Summary

6. Print a summary:
   ```
   Session summary:
   - TODOs completed: N
   - Key metrics: <any metrics that moved>
   - Lessons extracted: N
   - Skill diffs proposed: N
   ```

7. Tell the user: *"Review proposed diffs in `lessons/`. Merge with `git apply lessons/YYYYMMDD-slug.diff` or edit the SKILL.md directly."*

## Constraints

8. Never write directly to any `SKILL.md` file. Always propose. The human merges.
9. Create the `lessons/` directory if it does not exist.
