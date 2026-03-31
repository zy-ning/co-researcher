---
name: write
description: Drafts or revises a research paper from RESEARCH.md, producing paper.md and refs.bib. Marks ungrounded claims [UNGROUNDED] and unverified citations [UNVERIFIED] inline. Fixed sequence: outline → section drafts → self-consistency check → citation pass → auto-review. Respects RESEARCH.md supervision policy at major gates. Trigger phrases: "write paper", "draft paper", "revise paper", "start writing".
---

# Write

Draft the paper from `RESEARCH.md`. You can enter at any point in the research lifecycle.

## Prerequisites

1. Read `RESEARCH.md`. Apply supervision policy for `write-start` (approve → pause; notify → announce and continue; absent → proceed). If writing requires a compromise relative to the current plan, apply `Idea Changes` before proceeding.
2. Check **Context** for experiment results.
   - Results exist → use as empirical basis.
   - No results → ask: proceed with a results-free draft, or wait for experiments?

## Drafting Order

3. Follow this sequence strictly:
   1. **Outline** — section structure with bullet points for each section's argument.
   2. **Section drafts** — write each section, starting from the one with the strongest evidence.
   3. **Self-consistency check** — verify that claims in the abstract match claims in the body, numbers are consistent across sections, and the conclusion follows from the results.
   4. **Citation pass** — see below.

## Grounding Rule

4. Every quantitative claim must trace to a specific result in `RESEARCH.md` **Context**. If a claim cannot be traced, mark it inline: `[UNGROUNDED]`. Leave it visible for the user — do not silently remove it.

## Citation Pass

5. For every reference: search arXiv or resolve the DOI. If unverifiable, mark `[UNVERIFIED]`. Never fabricate a citation.

## Output

6. Default output: `paper.md` and `refs.bib` at the project root.
   **Escape hatch**: if a `.tex` file already exists at the project root, ask whether to write there instead.

## Post-Draft

7. Auto-invoke `review`. Write the score to `RESEARCH.md` **Context**. Apply stop policy (`target_reached`) or wild continuation as configured, otherwise ask: "Review score is X/10. Want a revision pass?"

## Partial State

8. If `paper.md` already exists, ask whether to continue from it or start fresh.

## Example

Input: RESEARCH.md with 2 completed experiments; user says "write the paper".
Output: paper.md (outline + 5 sections, 1 [UNGROUNDED] marker), refs.bib (8 entries, 1 [UNVERIFIED]), then auto-invokes `review`.
