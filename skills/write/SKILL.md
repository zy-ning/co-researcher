---
name: write
description: >-
  Drafts or revises a research paper from RESEARCH.md, producing paper.md and
  refs.bib. Use when starting a paper, continuing an existing draft, or
  revising after a review round. Works at any stage of the research lifecycle —
  marks ungrounded claims inline as [UNGROUNDED] and unverified citations as
  [UNVERIFIED] rather than silently omitting them. Follows a fixed sequence:
  outline → section drafts → self-consistency check → citation pass.
  Automatically invokes `review` after the draft completes. If `RESEARCH.md`
  includes a supervision policy, respect it at major writing gates. Trigger
  phrases: "write paper", "draft paper", "revise paper", "start writing".
---

# Write

Draft the paper from `RESEARCH.md`. You can enter at any point in the research lifecycle.

If `RESEARCH.md` includes `## Supervision Policy`, use it at major gates such as `write-start`, draft completion, revision decisions, and material idea changes in the paper plan. If the policy is absent, preserve the current behavior in this skill.

## Prerequisites

1. Read `RESEARCH.md`. Check whether **Context** contains experiment results.
   - If results exist → use them as the empirical basis for the paper.
   - If no results → tell the user and ask: proceed with a results-free draft, or wait for experiments?
   - If `Approve` includes `write-start`, pause for approval before drafting.
   - If `Notify` includes `write-start` but approval does not, announce the start of drafting and continue.
   - If writing requires a compromise or significant strategy pivot relative to the current plan, apply `Idea Changes` before proceeding.

## Drafting Order

2. Follow this sequence strictly:
   1. **Outline** — section structure with bullet points for each section's argument.
   2. **Section drafts** — write each section, starting from the one with the strongest evidence.
   3. **Self-consistency check** — verify that claims in the abstract match claims in the body, numbers are consistent across sections, and the conclusion follows from the results.
   4. **Citation pass** — see below.

## Grounding Rule

3. Every quantitative claim must trace to a specific result in `RESEARCH.md` **Context**. If a claim cannot be traced, mark it inline: `[UNGROUNDED]`. Do not silently remove ungrounded claims — leave them visible for the user.

## Citation Pass

4. For every reference in the paper:
   - Search arXiv (via web search) or resolve the DOI to verify the reference exists.
   - If the reference cannot be verified, mark it inline: `[UNVERIFIED]`.
   - Never fabricate a citation. If you cannot find the real reference, leave `[UNVERIFIED]` and move on.

## Output

5. Default output is two files at the project root:
   - `paper.md` — the full draft in markdown.
   - `refs.bib` — BibTeX entries for all citations.
   **Escape hatch**: If the project root already contains a `.tex` file, ask the user whether to write to that file instead of `paper.md`.

## Post-Draft

6. After completing the draft, invoke the `review` skill automatically. Write the review score to `RESEARCH.md` **Context**.
7. If `Stop` says to halt after the draft or first review, stop with reason `target_reached` after recording the result. If the preset is `wild` and completion criteria are still unmet, continue the revision loop within policy boundaries. Otherwise ask the user: "Review score is X/10. Want a revision pass?" If yes, address the top weaknesses and re-invoke `review`.

## Partial State

8. Handle partial state gracefully. If the user says "write the paper" and you find an existing `paper.md`, ask whether to continue from it or start fresh.

## Example

Input: RESEARCH.md with 2 completed experiments; user says "write the paper".
Output: paper.md (outline + 5 sections, 1 [UNGROUNDED] marker), refs.bib (8 entries, 1 [UNVERIFIED]), then auto-invokes `review`.
