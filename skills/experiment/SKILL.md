---
name: experiment
description: >-
  Runs ML experiments reproducibly — single runs or autonomous BFS batches.
  Single mode: isolated venv, time-budgeted, failure-handled, logs to
  RESEARCH.md. BFS mode (opt-in): designs N hypotheses, runs each for a fixed
  budget, compares via a single verifiable metric, keeps improvements and
  git-resets failures — fully autonomous until done. Respects the RESEARCH.md
  supervision policy for notifications, approvals, and stop limits. Trigger
  phrases: "run experiment", "train model", "explore design space", "find
  best config", "autoresearch".
---

# Experiment

Run experiments reproducibly. Log everything to `RESEARCH.md`.

If `RESEARCH.md` includes `## Supervision Policy`, apply it for notifications, approvals, resource boundaries, and stop limits. If absent, preserve the defaults below.

## Before Running

1. Use an isolated virtual environment. If none exists, create one first.
   **Escape hatch**: If the user has already activated a venv, skip this step.
2. Validate the target script before execution:
   ```bash
   python -m py_compile path/to/script.py
   ```
3. Set a fixed time budget per run. Default: **5 minutes**. Do not exceed without explicit user approval, even if the supervision preset is permissive.

## Single Run

4. Capture stdout and stderr to a log file.
5. Watch for: `NaN`/`Inf` in loss, OOM failures, silent hangs (>60s no output). Terminate and record on hang.
6. **Failure**: patch once, retry once. On second failure — stop with reason `error_threshold`, log to `RESEARCH.md` Context (script path, hash, error, patch, outcome), surface to user.
7. **Success**: extract key metrics, append structured block to `RESEARCH.md` Context (date, script hash, metrics, notes).

## BFS Mode — opt-in

Activate when the user asks to "explore", "autoresearch", or "find the best config". Requires two preconditions:
- A **single target file** the agent is allowed to modify (e.g., `train.py`).
- A **verifiable scalar metric** to minimize or maximize (e.g., `val_bpb`, `val_acc`). Must be extractable from run output with a grep/awk one-liner.

Apply supervision policy: notify on `experiment-start` if configured; require approval before entering the loop if `bfs-start` is in `Approve`; in `wild`, proceed only within already granted resource and budget boundaries.

**Loop** (runs autonomously until budget or N experiments exhausted):

8. Design the next hypothesis — one focused change to the target file (e.g., change learning rate schedule, add residual scaling, modify attention pattern). State the hypothesis in one line before modifying.
9. `git commit -am "hypothesis: <one-line description>"`
10. Run the script for the fixed time budget. Extract the metric:
    ```bash
    grep "^<metric_key>:" run.log | awk '{print $2}'
    ```
11. Compare to the current best:
    - **Improvement** → log as `keep` in `results.tsv`, update best.
    - **No improvement or failure** → `git reset --hard HEAD~1`, log as `discard`.
12. Append a row to `results.tsv`:
    ```
    commit_hash  metric_value  status   description
    ```
13. Loop to step 8. Do not pause to ask the user between iterations unless a configured stop target or hard limit has been reached, or a forbidden resource / approval boundary blocks further progress.

**End of batch**: write a summary table to `RESEARCH.md` Context; surface best commit and top 3. Apply stop policy (`target_reached`) or wild continuation as configured, otherwise ask: "Best result is `<hash>` (`<metric>=<value>`). Continue exploring or proceed to writing?"

**Constraints**: only modify the target file; one focused change per hypothesis; log every run including discards; supervision presets never override target-file, metric, budget, or resource boundaries.

## Example

**Single**: `python train.py --lr 0.01`, budget=5min → appends `2026-03-29 14:32 — val_acc=0.923, hash=abc1234` to RESEARCH.md Context.

**BFS**: target=`train.py`, metric=`val_bpb` (minimize), budget=5min/run, N=10 → runs 10 hypothesis variants autonomously, keeps 3 improvements, produces `results.tsv` + summary table in RESEARCH.md Context.
