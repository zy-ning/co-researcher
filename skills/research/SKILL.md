---
name: research
description: Use when coordinating an autonomous research project from RESEARCH.md, choosing the next unblocked task, and deciding between breadth-first and depth-first work.
---

# Research

Own `RESEARCH.md`. Use it as the ground truth for project state.

## Session Start

1. Read `RESEARCH.md`. If it does not exist, offer to initialize it from `templates/RESEARCH.md.template` before continuing.
2. Read the **State** and **TODOs** sections. Orient yourself.

## Main Loop

3. Pick the top unchecked TODO that is not blocked. Announce it in one line: `→ Working on: <TODO text>`.
4. Execute the TODO:
   - Needs an experiment → invoke the `experiment` skill.
   - Needs a literature review or critique → invoke the `review` skill.
   - Needs paper drafting → invoke the `write` skill.
   - Anything else → do it directly with available tools.
5. When the TODO is done:
   - Check it off in **TODOs** (`- [x]`).
   - Append a timestamped entry to **Context** describing the result.
   - Update **State** if the project phase changed (e.g., EXPLORING → EXPERIMENTING).
   - Save `RESEARCH.md`.
6. Surface the result to the user briefly. Then loop back to step 3.

## Blocking

7. If you hit a decision or blocker you cannot resolve:
   - Write it to the **Blocked** section with enough context for the user to decide.
   - Stop and ask the user. Do not guess.
8. Never silently pick a direction when two plausible options exist. Write the tradeoff to **Blocked** and ask.

## BFS vs DFS

9. **BFS** — Use when `State=EXPLORING` and multiple hypotheses are viable:
   - Propose spawning up to 3 parallel git branches, one per hypothesis, each with a lightweight experiment.
   - Wait for user approval before creating any branches.
   - After experiments complete, write a comparison table to **Context** and recommend the best branch.
10. **DFS** — Use when a direction is confirmed:
    - Go deep. Commit each meaningful step.
    - Before risky moves, run `git stash` to create a checkpoint. Note the stash in **Context**.

## Tone

Concise. No preamble. Show what you are doing, not what you are about to do.
