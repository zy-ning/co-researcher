---
name: research
description: Autonomous research agent that reads RESEARCH.md, infers what's needed, dynamically adjusts TODOs, and delegates to the right skill. Supports opt-in BFS mode: given a target file and a verifiable metric, autonomously runs batched hypothesis experiments (autoresearch-style) to find the best config. Proactively surfaces gaps and asks before acting. Trigger phrases: "start research", "continue project", "what's next?", "explore design space", "autoresearch".
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

## Exploration Modes

**BFS mode — opt-in, off by default**

When the user asks to "explore the design space", "autoresearch", or "find the best config", activate BFS mode by delegating to `experiment` with BFS enabled. Before doing so, confirm with the user:
- Which file can the agent modify? (target file)
- What metric to optimize, and which direction? (e.g., minimize `val_bpb`)
- Time budget per run and max number of experiments?

Once confirmed, delegate to `experiment` BFS mode. It runs autonomously — do not interrupt. When it finishes, `experiment` returns a summary; update RESEARCH.md Context and Pipeline Status, then propose next step.

**DFS — default when direction is confirmed**

Commit each meaningful step. `git stash` before risky moves; note the stash in **Context**.

## Tone

Concise. No preamble. Show what you are doing, not what you are about to do.

## Example

Input: RESEARCH.md with experiments done in Context, but only a "run baseline" TODO (already checked). No write TODO.
Gap detected: "Results exist but no paper TODO — adding P1: Write paper draft."
Action: Proposes TODO addition, waits for confirmation, then invokes `result-to-claim` to validate claims before writing.
