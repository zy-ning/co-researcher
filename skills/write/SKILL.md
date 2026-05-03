---
name: write
description: >-
  Drafts or revises a publication-ready research paper from RESEARCH.md,
  producing paper.md and refs.bib. Builds a clear claim-evidence narrative,
  writes in professional academic style, marks ungrounded claims [UNGROUNDED]
  and unverified citations [UNVERIFIED] inline, then auto-invokes review.
  Trigger phrases: "write paper", "draft paper", "revise paper", "start
  writing".
---

# Write

Draft the paper from `RESEARCH.md`. You can start writing at any point in the research lifecycle; use `[UNGROUNDED]` to track claims that still need evidence.

## Prerequisites

1. Read `RESEARCH.md`. Apply supervision policy for `write-start` (approve → pause; notify → announce and continue; absent → proceed). If writing requires a compromise relative to the current plan, apply `Idea Changes` before proceeding.
2. Check **Context** for experiment results.
   - Results exist → use as empirical basis.
   - No results → ask: proceed with a results-free draft, or wait for experiments?

## Narrative Framing

3. Before outlining, state the paper's contribution in **one sentence**. If you cannot, the framing has not converged — ask the user to clarify the intended story.
4. Build a compact claim-evidence map:
   - **Claim** — what the paper asserts.
   - **Evidence** — result, theorem, artifact, or citation supporting it.
   - **Section** — where the claim will appear.
   - Missing evidence → mark `[UNGROUNDED]` and keep drafting only if the user approved a results-free draft.

## Drafting Order

5. Follow this sequence strictly:
   1. **Outline** — section structure with bullet points for each section's argument. The outline should make one coherent story, not a list of experiments.
   2. **Section drafts** — write each section, starting from the one with the strongest evidence.
   3. **Self-consistency check** — verify that claims in the abstract match claims in the body, numbers are consistent across sections, and the conclusion follows from the results.
   4. **Citation pass** — see below.

## Grounding Rule

7. Every quantitative claim, dataset claim, baseline claim, theorem claim, and method-detail claim must trace to a specific source in `RESEARCH.md` **Context** or a verified citation. If a claim cannot be traced, mark it inline: `[UNGROUNDED]`. Leave the marker visible for the user — do not silently remove it.

## Style Pass

8. After drafting, polish for publication-ready academic prose:
   - Keep subject and verb close.
   - Use concrete verbs and consistent terminology.
   - Replace vague nouns like "performance" with the actual metric when known.
   - Remove filler and inflated language: "groundbreaking", "revolutionary", "delve", "pivotal", "landscape", "notably", "importantly", "it is worth noting".
   - Avoid generic conclusions such as "opens new avenues" unless the avenues are specific.
   - Run a reverse-outline test: read the first sentence of every paragraph in sequence. They should form a coherent argument on their own.

## Citation Pass

9. For every reference: search arXiv, resolve the DOI, or use another trusted source. If unverifiable, mark `[UNVERIFIED]`. **Never generate citations from memory.** Fabricated citations are academic misconduct.

## Output

10. Default output: `paper.md` and `refs.bib` at the project root.
    **Escape hatch**: if a `.tex` file already exists at the project root, ask whether to write there instead.
11. Before declaring done, check:
    - Abstract is self-contained.
    - Introduction claims have supporting evidence in the body.
    - Numbers are consistent across sections.
    - Terminology is consistent.
    - `[UNGROUNDED]` and `[UNVERIFIED]` markers are listed for the user.

## Post-Draft

12. Auto-invoke `review`. Write the score to `RESEARCH.md` **Context**. Apply stop policy (`target_reached`). In wild mode, continue if configured; otherwise ask: "Review score is X/10. Want a revision pass?"

## Partial State

13. If `paper.md` already exists, ask whether to continue from it or start fresh.

## Constraints

- Never fabricate results, citations, baselines, or venue claims.
- Never hide `[UNGROUNDED]` or `[UNVERIFIED]` markers.
- Do not turn `write` into compilation, figure generation, or experiment execution; delegate those to the relevant skill.

## Example

Input: RESEARCH.md with 2 completed experiments; user says "write the paper".
Output: paper.md (publication-ready narrative + 5 sections, 1 [UNGROUNDED] marker), refs.bib (8 entries, 1 [UNVERIFIED]), then auto-invokes `review`.
