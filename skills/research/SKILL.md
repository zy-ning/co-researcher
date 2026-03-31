---
name: research
description: >-
  Autonomous research agent that reads RESEARCH.md, infers what's needed,
  dynamically adjusts TODOs, and delegates to the right skill. Supports opt-in
  BFS mode: given a target file and a verifiable metric, autonomously runs
  batched hypothesis experiments (autoresearch-style) to find the best config.
  Proactively surfaces gaps and asks before acting unless a supervision policy
  says to notify or continue. Supports queued approvals, bounded resource
  delegation, idea-change reporting, and an explicit-confirmation `wild` mode.
  Trigger phrases: "start research", "continue project", "what's next?",
  "explore design space", "autoresearch", "automation level",
  "supervision policy", "/supervision".
---

# Research

Own `RESEARCH.md`. Use it as the ground truth for project state.

## Session Start

1. If `RESEARCH.md` does not exist, offer to initialize from `templates/RESEARCH.md.template` before continuing.
2. Read **Pipeline Status** first (30-second orient), then **Supervision Policy** if present, then the full document.

## Supervision Policy

3. `## Supervision Policy` is optional. If it is absent, preserve the current confirmation-first behavior in this skill.
4. If the user asks to configure automation, supervision, notifications, approval gates, stop targets, resources, or wild mode, update `## Supervision Policy` through a short interactive flow:
   - choose a preset: `manual`, `checkpointed`, `autonomous`, or `wild`
   - confirm notification events
   - confirm approval gates
   - confirm stop target / limits
   - confirm resource rules
   - confirm idea-change rules
   - confirm persistence in project state
5. Treat the policy as explicit dimensions:
   - **Notify** — events to surface before or after an action
   - **Approve** — action types that must pause for user approval
   - **Stop** — target or limits that halt autonomous continuation
   - **Resources** — what can be requested, used, or escalated
   - **Idea Changes** — whether improvements, pivots, and compromises notify or require approval
   - **Wild Mode** — non-stop execution within explicit risk-confirmed boundaries
6. Default preset is `checkpointed`: queue approval-requiring issues, notify if possible, and continue unrelated allowed work.
7. `wild` mode is never implicit. Before enabling it, warn the user that it can increase unattended actions, resource usage, and divergence from the original plan, then require explicit confirmation of those consequences.
8. Apply precedence in this order:
   - required approval
   - notification-only
   - silent continuation
9. If approval is required and the preset is `checkpointed`, record the issue under **Pending Approvals**, notify the user if possible, and continue unrelated allowed work. Stop with reason `awaiting_approval` only when no allowed work remains.
10. If approval is required and the preset is `manual` or the action cannot be bypassed safely, surface the request and stop with reason `awaiting_approval`.
11. If a configured stop target or limit is reached, stop with an explicit reason such as `target_reached`, `step_limit`, `time_budget`, `error_threshold`, or `blocked`.
12. If a task needs a resource beyond the granted policy scope, obey `Escalation beyond granted`:
   - `forbid` → do not ask; mark blocked
   - `notify` → notify the user, but do not request broader access automatically
   - `approve` → ask explicitly for approval
13. Treat resources in three classes:
   - **Service / API** — LLM APIs, SaaS, credentials, paid services
   - **Compute** — servers, GPUs, clusters, remote machines
   - **Human / Physical** — manual setup, human labor, physical-world tasks
14. When the agent improves, pivots, or compromises on the current idea, follow **Idea Changes**:
   - **Improvements** — usually notify
   - **Strategy pivots** — notify or ask depending on policy
   - **Compromises** — ask for approval by default
15. If `Notify` is configured but no notification channel exists, fall back to surfacing the event in the next user-visible update rather than inventing a channel.

## Assess Before Acting

16. Before executing any TODO, do a gap analysis:
   - Compare **Goal** against completed **Context** entries. What's clearly missing?
   - Surface any stale items in **Blocked** to the user immediately.
   - Examples of gaps to catch: experiment done but no result analysis TODO; results analyzed but no paper TODO; paper drafted but no review TODO.

17. If the TODO list is stale or incomplete, classify the action as `todo-adjustments` and then apply the supervision policy:
   - **Approve includes `todo-adjustments`** → propose the adjustments and wait.
   - **Notify includes `todo-adjustments` but approval does not** → announce the adjustments, apply them, and continue.
   - **No policy entry** → preserve today's behavior: propose adjustments and wait for confirmation.
   Then:
   - Add TODOs for obvious missing work.
   - Remove or defer TODOs made obsolete by Context entries.
   - Reorder by priority if circumstances changed.

## Act

18. Pick the highest-priority unblocked TODO. Announce: `→ Working on: <TODO text>`.

19. Delegate to the right skill:

   | Need | Skill |
   |------|-------|
   | Literature survey | `research-lit` or `arxiv` |
   | Deep paper Q&A / code repo discovery | `alpha-research` (AlphaXiv CLI: `alpha ask`, `alpha repo`) |
   | Paper-to-code reproducibility audit | `audit` |
   | Method / idea refinement | `research-refine` |
   | Experiment planning | `experiment-plan` |
   | Running experiments | `experiment` (this pack) or `run-experiment` |
   | Result analysis | `result-to-claim` |
   | Figures | `paper-figure` |
   | Paper drafting | `write` (this pack) or `paper-write` |
   | Review / critique | `review` (this pack) or `auto-review-loop` |
   | Lesson extraction | `evolve` (this pack) |
   | Unclear | Ask the user which skill fits, or do it directly. |

20. When done: check off TODO (`- [x]`), append timestamped **Context** entry, update **State** if phase changed, update **Pipeline Status**, save `RESEARCH.md`.

## Proactive Loop

21. After each completed TODO, surface the result briefly, then classify the next move:
   - **Ambiguous** → describe 2–3 options and ask which to pursue. Never silently pick among plausible directions.
   - **Approve includes `continue` or stop target is reached** → ask before proceeding, or queue and continue if the preset explicitly allows that and unrelated work exists.
   - **Notify includes `continue` but approval does not** → announce the next action and continue.
   - **Preset is `wild`** → continue without asking until completion criteria, a hard safety rule, or a forbidden boundary is hit.
   - **No policy entry** → preserve today's behavior: announce the next action and ask "Shall I continue?"

22. Never silently pick a direction when two plausible paths exist. Write the tradeoff to **Blocked** and ask, unless the policy explicitly says such pivots are notify-only.

## Exploration Modes

**BFS mode — opt-in, off by default**

When the user asks to "explore the design space", "autoresearch", or "find the best config", activate BFS mode by delegating to `experiment` with BFS enabled. Before doing so, classify the action as `bfs-start` and use the supervision policy:
- If `Approve` includes `bfs-start`, confirm with the user.
- If `Notify` includes `bfs-start` but approval does not, announce the BFS launch and continue.
- If no policy entry exists, preserve today's behavior and confirm with the user.

If the preset is `wild`, BFS may proceed without a fresh checkpoint only when the target file, metric, budget, and completion criteria are already explicit and within granted policy boundaries.

Before BFS begins, confirm or preserve these guardrails:
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
