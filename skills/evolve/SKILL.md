# Evolve Skill

Runs at session end. Instructions:

1. Read RESEARCH.md History + git log for this session.
2. Identify candidate lessons: things that failed, unexpected results, 
   debugging insights, workflow improvements.
3. Apply generalize filter: ask "would this lesson help in a different project 
   on a different topic?" If no → discard. If yes → proceed.
4. For each generalizable lesson: write a LESSON.md file using the template.
   Save to lessons/YYYYMMDD-slug.md. Set Status: PROPOSED.
5. For each lesson that affects a skill: propose a specific diff to that SKILL.md.
   Write the proposed diff inline in the LESSON.md under ## Proposed diff.
6. Print a session summary: TODOs completed, metrics moved, lessons extracted, 
   diffs proposed.
7. Tell the user: "Review proposed diffs in lessons/. Merge with: 
   `git apply lessons/YYYYMMDD-slug.diff` or edit SKILL.md directly."
8. Never write directly to SKILL.md. Always propose. Human merges.