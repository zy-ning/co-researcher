---
name: review
description: Use when critiquing a research draft, result summary, or paper with a separate model and checking evidence, citations, and ablation support.
---

# Review

Run an adversarial review with a **different** model. Never review your own work.

## Critic Selection

1. Use the Codex MCP server (`mcp__codex__codex`) as the critic model. It must be a different model from you.
2. If Codex MCP is unavailable or not configured, say so and **stop**. Do not fall back to self-review.

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

4. The critic must return a structured result:
   ```json
   {
     "score": "X/10",
     "verifiable_failures": ["..."],
     "subjective": { "clarity": N, "novelty": N, "writing": N },
     "top_3_weaknesses": ["..."],
     "recommended_action": "PROCEED | REFINE | PIVOT"
   }
   ```

## Integrity Checks

5. If the score rises between rounds without corresponding verifiable improvements (new experiments, fixed citations), flag it as **potential reward hacking**. Write a warning to `RESEARCH.md` **Context**.
6. Include this instruction verbatim in every prompt to the critic: *"Do not hide weaknesses to game a positive score."*

## Limits

7. Run at most **4 review rounds** per session. After round 4, escalate to the user regardless of score.
8. After each round, write the score and top weaknesses to `RESEARCH.md` **Context**.
