---
name: supervision
description: >-
  Configure the project's supervision policy in RESEARCH.md. Uses a preset-first
  flow (`manual`, `checkpointed`, `autonomous`, `wild`), then lets the user
  adjust notification events, approval gates, stop limits, resource rules, and
  idea-change handling. Trigger phrases: "configure supervision", "set
  supervision", "automation settings", "change autonomy", "/supervision".
---

# Supervision

Use this skill when the user wants to configure how much autonomy the agent should use for the current project.

## Scope

This skill manages `## Supervision Policy` in `RESEARCH.md`.

If the user wants to configure both supervision and preferred skillpacks together, prefer `customize` and keep this skill focused on supervision only.

## Flow

Use a preset-first flow:

1. choose a preset: `manual`, `checkpointed`, `autonomous`, or `wild`
2. confirm notification events
3. confirm approval gates
4. confirm stop target / limits
5. confirm resource rules
6. confirm idea-change handling
7. write the policy into `RESEARCH.md`

## Precedence

`RESEARCH.md` `## Supervision Policy` is the live working-state layer and overrides everything.
`.co-researcher/skills.yaml` `supervision` is the project-default layer written by `customize` — only consulted when `RESEARCH.md` has no policy yet.

## Constraints

- Do not create a separate hidden config store for supervision.
- Keep the policy human-readable.
- If `RESEARCH.md` is missing, initialize it before editing.
- `wild` is never implicit; require explicit user confirmation.
