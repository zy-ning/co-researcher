---
name: experiment
description: Runs a single ML experiment or a batch of competing hypotheses reproducibly. Use when executing a training script, debugging a failing run, comparing multiple model variants on parallel git branches, or any time experiment results need to be logged to RESEARCH.md. Enforces isolated virtual environments, a 5-minute time budget by default, and a one-patch/one-retry failure policy. Writes structured result blocks (date, script hash, key metrics) back to RESEARCH.md Context. Trigger phrases: "run experiment", "train model", "test hypothesis", "compare variants".
---

# Experiment

Run experiments reproducibly. Log what happened. Write results back to `RESEARCH.md`.

## Before Running

1. Use an isolated virtual environment for every experiment run. If no venv exists, create one first.
   **Escape hatch**: If the user has already activated a venv and explicitly says to use the current environment, skip this step.
2. Validate that the target script parses cleanly before execution:
   ```bash
   python -m py_compile path/to/script.py
   ```
3. Set a fixed time budget. Default: **5 minutes**. Do not exceed it unless the user explicitly approves.

## Execution

4. Capture both stdout and stderr to a log file.
5. While the run is active, watch for:
   - `NaN` or `Inf` in loss or metrics
   - out-of-memory failures
   - silent hangs with no output for more than 60 seconds
6. If the run hangs, terminate it, record the hang in `RESEARCH.md`, and decide whether a single retry is justified.

## Failure Handling

7. On failure, read the error carefully. Patch the script once. Retry once.
8. If the retry fails, stop. Append a timestamped entry to `RESEARCH.md` **Context** with:
   - script path
   - script hash or commit
   - error message
   - patch attempt
   - outcome of the retry
9. Surface the failure briefly to the user. Do not keep retrying.

## Success Handling

10. On success, extract the key metrics from the log and append a structured result block to `RESEARCH.md` **Context** with:
    - date
    - script hash
    - key metrics
    - notes

## BFS Mode

11. If invoked with multiple hypotheses, create one git branch per hypothesis.
12. Run the experiments sequentially or in background processes, whichever best fits the resource budget.
13. Collect the results into a comparison table in `RESEARCH.md` **Context**.
14. Recommend the best branch based on the logged metrics, not intuition.

## Example

Input: `python train.py --lr 0.01`, budget=5min.
Success: Appends `2026-03-29 14:32 — val_acc=0.923, loss=0.21, hash=abc1234` to RESEARCH.md Context.
Failure: Patches once, retries once, then surfaces error and stops.
