---
name: review
description: Runs an adversarial critique of a research draft or paper using the Codex MCP server as an external critic model. Use when a paper draft is complete or partially complete, after each writing round, or when `write` invokes it automatically. Checks verifiable claims against RESEARCH.md, validates citations via DOI/arXiv lookup, and scores novelty and clarity. Returns a structured JSON score (0–10) with top weaknesses and a PROCEED/REFINE/PIVOT recommendation. Caps at 4 rounds per session. Trigger phrases: "review paper", "critique draft", "check citations", "adversarial review".
---

# Review

Run an adversarial review with a **different** model. Never review your own work.

## Critic Selection

1. Use the first available external critic in priority order:
   - `codex:codex` (Codex MCP) — preferred
   - `auto-review-loop-llm` skill (any OpenAI-compatible endpoint) — fallback
   - `auto-review-loop-minimax` skill (MiniMax) — fallback
2. Record which critic was used in `RESEARCH.md` **Context** alongside the score.
3. If no external critic is available, say so and **stop**. Do not self-review.

## Review Rubric (Fixed — Do Not Modify)

3. Send the work to the critic with this exact rubric:

**VERIFIABLE** (graded on evidence, not opinion):
- Every claim maps to an experiment result in `RESEARCH.md` **Context**. Flag claims that don't.
- No hallucinated citations. Check every DOI and arXiv ID. Flag any that don't resolve.
- Ablations support stated conclusions. Check the numbers match.

**SUBJECTIVE** (graded by the critic):
- Clarity of problem statement (1–5)
- Novelty relative to cited work (1–5)
- Writing quality (1–5)

4. The critic must return a structured result matching the schema in `RUBRIC.md`. See `RUBRIC.md` for field definitions, the PROCEED/REFINE/PIVOT decision rules, and the verbatim integrity instruction to include in every critic prompt.

## Integrity Checks

5. If the score rises between rounds without corresponding verifiable improvements (new experiments, fixed citations), flag it as **potential reward hacking**. Write a warning to `RESEARCH.md` **Context**.

## Limits

6. Run at most **4 review rounds** per session. After round 4, escalate to the user regardless of score.
7. After each round, write the score and top weaknesses to `RESEARCH.md` **Context**.

## Example

Input: paper.md with 3 quantitative claims; 1 claim lacks a matching RESEARCH.md result.
Output: score=6/10, verifiable_failures=["Table 2 improvement not in Context"], recommended_action=REFINE.
