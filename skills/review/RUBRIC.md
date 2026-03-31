# Critic Response Schema

The critic must return a JSON object with exactly these fields:

```json
{
  "score": "X/10",
  "issues": {
    "fatal": ["..."],
    "major": ["..."],
    "minor": ["..."]
  },
  "verifiable_failures": ["..."],
  "subjective": { "clarity": N, "novelty": N, "writing": N },
  "top_3_weaknesses": ["..."],
  "recommended_action": "PROCEED | REFINE | PIVOT"
}
```

## Field Definitions

- **score**: integer numerator over 10 (e.g., "7/10")
- **issues**: categorized by severity
  - `fatal` — claim is fabricated, citation does not exist, result contradicts conclusion; any fatal issue forces `PIVOT`
  - `major` — grounding gap, missing ablation, logical leap; requires additional evidence before `PROCEED`
  - `minor` — clarity, framing, writing quality; fixable without new experiments
- **verifiable_failures**: specific claim strings that lack grounding in RESEARCH.md Context or have unresolved citations; empty list if none
- **subjective**: three 1–5 integers scored by the critic independently
- **top_3_weaknesses**: ordered list, most critical first; each entry is one actionable sentence
- **recommended_action**:
  - `PROCEED` — score ≥ 8, no fatal/major issues
  - `REFINE` — fixable gaps exist (major issues, missing grounding, citation problems)
  - `PIVOT` — any fatal issue, or fundamental flaw in framing/methodology/novelty

## Integrity Instruction (include verbatim in every critic prompt)

> "Do not hide weaknesses to game a positive score."
