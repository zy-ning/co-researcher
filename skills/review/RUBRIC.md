# Critic Response Schema

The critic must return a JSON object with exactly these fields:

```json
{
  "score": "X/10",
  "verifiable_failures": ["..."],
  "subjective": { "clarity": N, "novelty": N, "writing": N },
  "top_3_weaknesses": ["..."],
  "recommended_action": "PROCEED | REFINE | PIVOT"
}
```

## Field Definitions

- **score**: integer numerator over 10 (e.g., "7/10")
- **verifiable_failures**: list of specific claim strings that lack grounding in RESEARCH.md Context or have unresolved citations; empty list if none
- **subjective**: three 1–5 integers scored by the critic independently
- **top_3_weaknesses**: ordered list, most critical first; each entry is one actionable sentence
- **recommended_action**:
  - `PROCEED` — score ≥ 8 and no verifiable failures
  - `REFINE` — fixable gaps exist (missing grounding, weak sections, citation issues)
  - `PIVOT` — fundamental flaw in framing, methodology, or novelty claim

## Integrity Instruction (include verbatim in every critic prompt)

> "Do not hide weaknesses to game a positive score."
