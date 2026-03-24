---
name: write
description: Use when drafting or revising a paper from RESEARCH.md, including cases where results are partial, missing, or still being validated.
---

# Write

Draft the paper from `RESEARCH.md`. You can enter at any point in the research lifecycle.

## Prerequisites

1. Read `RESEARCH.md`. Check whether **Context** contains experiment results.
   - If results exist → use them as the empirical basis for the paper.
   - If no results → tell the user and ask: proceed with a results-free draft, or wait for experiments?

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

5. Write two files to the project root:
   - `paper.md` — the full draft in markdown.
   - `refs.bib` — BibTeX entries for all citations.

## Post-Draft

6. After completing the draft, invoke the `review` skill automatically. Write the review score to `RESEARCH.md` **Context**.
7. Ask the user: "Review score is X/10. Want a revision pass?" If yes, address the top weaknesses and re-invoke `review`.

## Partial State

8. Handle partial state gracefully. If the user says "write the paper" and you find an existing `paper.md`, ask whether to continue from it or start fresh.
