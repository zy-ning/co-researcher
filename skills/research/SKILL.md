---
name: research
description: >-
  Autonomous research agent that reads RESEARCH.md, infers what's needed,
  dynamically adjusts TODOs, and delegates to the right skill. Supports opt-in
  BFS mode for autonomous design space search. Respects a configurable
  supervision policy (presets: manual / checkpointed / autonomous / wild)
  governing notifications, approval gates, resource limits, and idea-change
  handling. Proactively surfaces gaps and asks before acting. Trigger phrases:
  "start research", "continue project", "what's next?", "explore design
  space", "autoresearch".
---

# Research

Own `RESEARCH.md`. Use it as the ground truth for project state.

## Session Start

1. If `RESEARCH.md` does not exist, initialize the project:
   - If `templates/RESEARCH.md.template` exists locally, copy it.
   - Otherwise, download it (and `CLAUDE.md`) from the pack's GitHub repo:
      ```bash
      mkdir -p templates
      curl -fsSL https://raw.githubusercontent.com/zy-ning/Oh_My_Co-Researcher/main/templates/RESEARCH.md.template -o templates/RESEARCH.md.template
      curl -fsSL https://raw.githubusercontent.com/zy-ning/Oh_My_Co-Researcher/main/CLAUDE.md -o CLAUDE.md
      cp templates/RESEARCH.md.template RESEARCH.md
      ```
   - Ask the user to fill in `## Goal`, then proceed.
2. If `.co-researcher/skills.yaml` exists, read it before planning so you know the project's preferred skillpacks, subset choices, and supervision defaults.
3. Read **Pipeline Status** first (30-second orient), then **Supervision Policy** if present, then the full document.

## Supervision Policy

4. `## Supervision Policy` in RESEARCH.md is optional. If absent, default to confirmation-first behavior throughout unless `.co-researcher/skills.yaml` specifies project-local supervision defaults.
5. Precedence rule:
   - `RESEARCH.md` `## Supervision Policy` overrides everything when present.
   - `.co-researcher/skills.yaml` provides project-local defaults when RESEARCH.md does not define supervision policy yet.
   - preset values are only the starting recommendation written by `customize`.
6. If `.co-researcher/skills.yaml` exists, treat it as the project-local preference layer for preferred presets, enabled packs, selected donor skills, and supervision defaults.
7. If the user asks to configure automation, supervision, or preferred skillpacks, use `customize` as the primary flow. Use direct inline RESEARCH.md edits only for lightweight policy adjustments when the user clearly wants that.
8. Policy dimensions:
   - **Notify** — events to surface; if no channel exists, surface in the next user-visible update
   - **Approve** — action types requiring a pause; precedence: approval > notify-only > silent
   - **Stop** — target or limits (`target_reached`, `step_limit`, `time_budget`, `error_threshold`, `blocked`)
   - **Resources** — three classes: Service/API, Compute, Human/Physical; escalation rule is `forbid` / `notify` / `approve`
   - **Idea Changes** — improvements (notify), strategy pivots (notify or approve), compromises (approve by default)
9. Preset behavior:
   - `manual` — always stop for approval
   - `checkpointed` (default) — record approval-required issues in **Pending Approvals**, continue unrelated allowed work; stop only when nothing else remains
   - `autonomous` — notify but do not stop
   - `wild` — never implicit; warn the user about unattended actions, resource use, and plan divergence, then require explicit confirmation before enabling

## Assess Before Acting

10. Before executing any TODO, do a gap analysis:
   - Compare **Goal** against completed **Context** entries. What's missing?
   - Surface stale **Blocked** items immediately.
   - Gaps to catch: experiment done but no result analysis; results done but no paper; paper drafted but no review.

11. If the TODO list is stale or incomplete, apply the supervision policy for `todo-adjustments` (approve → wait; notify → announce and continue; absent → propose and wait), then add/remove/reorder as needed.

## Act

12. Pick the highest-priority unblocked TODO. Announce: `→ Working on: <TODO text>`.

13. Delegate to the right skill:

   | Need | Skill |
   |------|-------|
   | Literature survey | `research-lit` or `arxiv` |
   | Deep paper Q&A / code repo discovery | `alpha-research` (AlphaXiv: `alpha ask`, `alpha repo`) |
   | Paper-to-code reproducibility audit | `audit` |
   | Method / idea refinement | `research-refine` |
   | Experiment planning | `experiment-plan` |
   | Running experiments | `experiment` (this pack) or `run-experiment` |
   | Result analysis | `result-to-claim` |
   | Figures | `paper-figure` |
   | Paper drafting | `write` (this pack) or `paper-write` |
   | Review / critique | `review` (this pack) or `auto-review-loop` |
   | Lesson extraction | `evolve` (this pack) |
   | Unclear | Ask the user, or do it directly. |

14. When done: check off TODO, append timestamped **Context** entry, update **State** and **Pipeline Status**, save `RESEARCH.md`.

## Proactive Loop

15. After each completed TODO, surface the result briefly, then apply the supervision policy for the next move:
   - **Ambiguous next step** → describe 2–3 options and ask. Never silently pick among plausible directions.
   - **Approve / stop target reached** → ask before proceeding, or queue and continue unrelated work if `checkpointed`.
   - **Notify only** → announce the next action and continue.
   - **Wild** → continue until completion criteria, a hard safety rule, or a forbidden boundary.
   - **No policy** → announce and ask "Shall I continue?"

## Exploration Modes

**BFS mode — opt-in, off by default**

When the user asks to "explore the design space", "autoresearch", or "find the best config", apply the supervision policy for `bfs-start` (approve → confirm; notify → announce and continue; absent → confirm). In `wild` mode, BFS may proceed without a checkpoint only when target file, metric, budget, and completion criteria are already explicit and within granted resource boundaries.

Before starting, confirm: target file, metric + direction (e.g., minimize `val_bpb`), time budget per run, max experiments. Then delegate to `experiment` BFS mode — do not interrupt. When done, update RESEARCH.md Context and Pipeline Status and propose next step.

**DFS — default when direction is confirmed**

Commit each meaningful step. `git stash` before risky moves; note the stash in **Context**.

## Project-local Skill Config

16. `.co-researcher/skills.yaml` is optional. If absent, keep existing behavior.
17. If present, use it to prefer enabled donor packs and selected skills when choosing among overlapping external tools.
18. Do not silently rewrite `.co-researcher/skills.yaml` during normal orchestration. Use `customize` when the user wants to change stack or supervision preferences.

## Tone

Concise. No preamble. Show what you are doing, not what you are about to do.

## Example

Input: RESEARCH.md with experiments done in Context, but only a "run baseline" TODO (already checked). No write TODO.
Gap detected: "Results exist but no paper TODO — adding P1: Write paper draft."
Action: Proposes TODO addition, waits for confirmation, then invokes `result-to-claim` to validate claims before writing.
