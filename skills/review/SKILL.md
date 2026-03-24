# Review Skill

Adversarial cross-model critique. Instructions:

1. The critic model must be DIFFERENT from the executing agent. 
   Use the Codex MCP server (already configured as `mcp__codex__codex`).
   If Codex MCP is unavailable, say so and stop — do not self-review.
2. The review rubric is FIXED. Do not ask the actor to adjust it. Rubric:
   VERIFIABLE (graded on evidence, not opinion):
     - Every claim maps to an experiment result in RESEARCH.md Context
     - No hallucinated citations (check DOI/arXiv IDs)
     - Ablations support stated conclusions (check the numbers)
   SUBJECTIVE (graded by critic LLM):
     - Clarity of problem statement (1-5)
     - Novelty relative to cited work (1-5)  
     - Writing quality (1-5)
   Return: { score: X/10, verifiable_failures: [...], subjective: {...}, 
             top_3_weaknesses: [...], recommended_action: PROCEED|REFINE|PIVOT }
3. If score rises without verifiable improvements: flag as potential reward hacking.
   Write a warning to RESEARCH.md Context.
4. Max 4 review rounds per session. After round 4, escalate to user regardless.
5. Rule: "Do not hide weaknesses to game a positive score." Explicit in prompt to critic.