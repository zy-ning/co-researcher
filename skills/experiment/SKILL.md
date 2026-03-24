# Experiment Skill

Instructions for running ML experiments:

1. Always run in an isolated venv. If one doesn't exist, create it first.
2. Before running: validate the script parses cleanly (python -m py_compile).
3. Run with a fixed time budget (default 5 min). Capture stdout/stderr to a log file.
4. Monitor for: NaN/Inf in loss, OOM, silent hangs (no output for >60s).
5. On failure: read the error, patch the script, retry once. If it fails again, 
   write the error + patch attempt to RESEARCH.md Context and surface to user.
6. On success: extract key metrics from the log, write a structured result block 
   to RESEARCH.md Context. Format: date, script hash, key metrics, notes.
7. BFS mode (when invoked with multiple hypotheses): create one git branch per 
   hypothesis, run experiments sequentially or in background processes, collect 
   results, write a comparison table to Context, recommend the best branch.
8. Never run experiments that exceed the time budget without explicit user approval.