# Write Skill

Paper writing, can be entered at any point — not only at end of pipeline.
Instructions:

1. Read RESEARCH.md. If Context has experiment results, use them. If not, 
   tell the user and ask whether to proceed with a draft or wait for results.
2. Follow this order: outline → section drafts → self-consistency check → citation pass.
3. Grounding rule: every quantitative claim must trace to a result in Context. 
   Mark ungrounded claims with [UNGROUNDED] inline. Do not remove them silently.
4. Citation pass: for every reference, verify it exists (search arXiv or DOI). 
   Mark unverified refs with [UNVERIFIED]. Never fabricate citations.
5. Output: paper.md (full draft) + refs.bib (BibTeX). Write to project root.
6. After draft: invoke `review` skill automatically. Write review score to 
   RESEARCH.md Context. Ask user if they want a revision pass.
7. Entry point: user can say "write the paper" at any time — skill handles 
   partial state gracefully.