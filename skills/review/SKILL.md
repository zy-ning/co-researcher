---
name: review
description: >-
  Adversarial critique of a research draft or paper using an isolated critic
  context. The critic must have no access to the current conversation history —
  context isolation, not model identity, is what makes the review independent.
  Use when a draft is complete or partially complete, after each writing round,
  or when `write` invokes it automatically. Returns FATAL/MAJOR/MINOR issues, a
  structured score (0–10), and a PROCEED/REFINE/PIVOT recommendation. Caps at 4
  rounds. Trigger phrases: "review paper", "critique draft", "check
  citations", "adversarial review".
---

# Review

Run an adversarial review in an **isolated context**. The critic must have no access to the current conversation history — this is what makes the critique independent, not which model is used.

## Critic Selection

1. Use the first available isolated critic in priority order:
   - Claude subagent (via `Task` tool or similar) with a clean context — preferred when no external MCP is configured, same model is fine
   - `codex:codex` (Codex MCP) — isolated by the MCP boundary
   - `auto-review-loop-llm` skill (any OpenAI-compatible endpoint)
   - `auto-review-loop-minimax` skill (MiniMax)
2. Record which critic was used in `RESEARCH.md` **Context** alongside the score.
3. If no isolated context can be established, say so and **stop**. Do not review within the same conversation context.

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
