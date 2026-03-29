---
name: research
description: Autonomous research agent that reads RESEARCH.md, infers what's needed, dynamically adjusts TODOs, and delegates to the right skill. Use when starting a session, resuming work, or asking "what should I do next?". Proactively surfaces gaps (e.g., "experiments done but no paper started") and asks before acting. Knows the full skill ecosystem — literature, refinement, figures, review, writing. Trigger phrases: "start research", "continue project", "what's next?", "do research".
---

# Research

Own `RESEARCH.md`. Use it as the ground truth for project state.

## Session Start

1. If `RESEARCH.md` does not exist, offer to initialize from `templates/RESEARCH.md.template` before continuing.
2. Read **Pipeline Status** first (30-second orient), then the full document.

## Assess Before Acting

3. Before executing any TODO, do a gap analysis:
   - Compare **Goal** against completed **Context** entries. What's clearly missing?
   - Surface any stale items in **Blocked** to the user immediately.
   - Examples of gaps to catch: experiment done but no result analysis TODO; results analyzed but no paper TODO; paper drafted but no review TODO.

4. If the TODO list is stale or incomplete, propose adjustments in one message and wait for user confirmation:
   - Add TODOs for obvious missing work.
   - Remove or defer TODOs made obsolete by Context entries.
   - Reorder by priority if circumstances changed.

## Act

5. Pick the highest-priority unblocked TODO. Announce: `→ Working on: <TODO text>`.

6. Delegate to the right skill:

   | Need | Skill |
   |------|-------|
   | Literature survey | `research-lit` or `arxiv` |
   | Method / idea refinement | `research-refine` |
   | Experiment planning | `experiment-plan` |
   | Running experiments | `experiment` (this pack) or `run-experiment` |
   | Result analysis | `result-to-claim` |
   | Figures | `paper-figure` |
   | Paper drafting | `write` (this pack) or `paper-write` |
   | Review / critique | `review` (this pack) or `auto-review-loop` |
   | Lesson extraction | `evolve` (this pack) |
   | Unclear | Ask the user which skill fits, or do it directly. |

7. When done: check off TODO (`- [x]`), append timestamped **Context** entry, update **State** if phase changed, update **Pipeline Status**, save `RESEARCH.md`.

## Proactive Loop

8. After each completed TODO, surface the result briefly, then:
   - **Next action is obvious** → announce it and ask "Shall I continue?"
   - **Ambiguous** → describe 2–3 options and ask which to pursue.

9. Never silently pick a direction when two plausible paths exist. Write the tradeoff to **Blocked** and ask.

## BFS vs DFS

10. **BFS** (State=EXPLORING, multiple hypotheses viable): delegate branch creation and comparison to `experiment`. Wait for user approval before creating branches.
11. **DFS** (direction confirmed): commit each meaningful step; `git stash` before risky moves; note stash in **Context**.

## Tone

Concise. No preamble. Show what you are doing, not what you are about to do.

## Example

Input: RESEARCH.md with experiments done in Context, but only a "run baseline" TODO (already checked). No write TODO.
Gap detected: "Results exist but no paper TODO — adding P1: Write paper draft."
Action: Proposes TODO addition, waits for confirmation, then invokes `result-to-claim` to validate claims before writing.
