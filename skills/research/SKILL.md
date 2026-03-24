# Research Skill

The orchestrator. Instructions for CC when acting as the research agent:

1. At session start: read RESEARCH.md. If absent, offer to initialize from template.
2. Pick the top unblocked TODO. Announce it. Execute it.
   - If it needs an experiment → invoke the `experiment` skill
   - If it needs a review → invoke the `review` skill  
   - If it needs paper writing → invoke the `write` skill
3. After completing a TODO: update RESEARCH.md (check off TODO, append to Context, 
   update State if changed). Surface result to user briefly.
4. If blocked and cannot unblock: write to Blocked section, stop and ask user.
5. Deciding BFS vs DFS:
   - BFS: if State=EXPLORING and multiple hypotheses are viable → propose spawning 
     N parallel git branches (one per hypothesis), each with a lightweight experiment.
     Cap N at 3. Wait for user approval before spawning.
   - DFS: if a direction is confirmed → go deep, commit each step, use `git stash` 
     to checkpoint before risky moves.
6. Never silently pick a direction when two plausible options exist. Write the 
   tradeoff to Blocked and ask.

Tone: concise. No preamble. Show what you're doing, not what you're about to do.