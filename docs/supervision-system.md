# Supervision System

`oh-my-coresearcher` uses a supervision system so the user can control how much autonomy the agent has without introducing a separate runtime or config subsystem.

The source of truth is still markdown: supervision policy lives in `RESEARCH.md` under `## Supervision Policy`.

If that section is absent, the repository keeps its original confirmation-first behavior.

## What the supervision system controls

The policy is split into explicit dimensions instead of one opaque "automation level":

- **Preset** — high-level operating style
- **Notify** — which events should be surfaced
- **Approve** — which actions require explicit approval
- **Stop** — when autonomous continuation should stop
- **Resources** — what resources can be requested or used
- **Idea Changes** — how the agent should handle improvements, pivots, and compromises
- **Wild Mode** — optional non-stop execution with explicit risk confirmation

## Presets

### `manual`

- asks often
- stops at major gates
- good for early-stage work or high-risk projects

### `checkpointed`

- default preset
- if an approval gate is hit, the agent can queue the issue and continue unrelated allowed work
- good balance between control and throughput

### `autonomous`

- continues without routine checkpoints
- still respects approval gates, stop limits, and resource boundaries

### `wild`

- non-stop execution until completion criteria or a hard boundary is reached
- only available after explicit confirmation of the consequences
- intended to be high-agency, not default

## Notifications and approvals

Typical notification events:

- `approval-required`
- `failure`
- `completion`
- `improvement`
- `strategy-pivot`

Typical approval gates:

- `todo-adjustments`
- `bfs-start`
- `write-start`
- `compromises`
- `risky-actions`

Precedence rule:

1. approval required
2. notify-only
3. silent continuation

## Queued approvals

In `checkpointed` mode, the agent does not have to stop immediately every time it needs approval.

Instead it can:

1. record the issue under `### Pending Approvals`
2. notify the user if a channel exists
3. continue unrelated allowed work
4. stop only when no allowed work remains or a hard boundary is hit

This keeps the system productive without making it reckless.

## Resource policy

Resources are split into three classes:

### Service / API

Examples:

- LLM APIs
- SaaS services
- service credentials

### Compute

Examples:

- servers
- GPUs
- clusters
- remote environments

### Human / Physical

Examples:

- manual setup
- human labor
- physical-world tasks or devices

Each class can be configured as:

- `forbid`
- `approve`
- `pre-granted`

The extra guardrail is:

- **Escalation beyond granted**

Recommended default: `forbid`

That means the user can pre-grant specific resources and prevent the agent from asking for anything broader.

## Idea changes

Idea changes are not treated as one bucket. The system separates:

- **Improvements** — better version of the same direction
- **Strategy pivots** — meaningful method or plan changes
- **Compromises** — degraded or weaker alternatives due to constraints

Recommended defaults:

- improvements → `notify`
- strategy pivots → `notify`
- compromises → `approve`

This lets users see meaningful evolution without turning every improvement into a blocking checkpoint.

## Wild mode

`wild` mode is the closest thing to a non-stop loop.

It should only be enabled after the user explicitly confirms possible consequences, such as:

- higher unattended resource use
- more divergence from the original plan
- longer stretches of work before review
- more accumulated speculative work

Even in `wild` mode, the agent must still stop for:

- forbidden resource requests
- hard safety boundaries
- unrecoverable blocked states
- completion criteria

`wild` is powerful, but it is not permission to ignore explicit constraints.

## Example policy

```md
## Supervision Policy
- **Preset**: checkpointed
- **Persistence**: project

### Notify
- approval-required
- failure
- completion
- improvement
- strategy-pivot

### Approve
- todo-adjustments
- bfs-start
- write-start
- compromises
- risky-actions

### Stop
- **Target**: queue-and-continue
- **Max steps**: —
- **Max errors**: —
- **Timeout minutes**: —

### Pending Approvals
- (record queued approvals here when allowed work can continue)

### Resources
- **Escalation beyond granted**: forbid

#### Service / API
- **Mode**: approve
- **Allowed**: —
- **Forbidden**: —

#### Compute
- **Mode**: approve
- **Allowed**: —
- **Forbidden**: —

#### Human / Physical
- **Mode**: approve
- **Allowed**: —
- **Forbidden**: —

### Idea Changes
- **Improvements**: notify
- **Strategy pivots**: notify
- **Compromises**: approve

### Wild Mode
- **Enabled**: no
- **Requires explicit risk confirmation**: yes
- **Completion criteria**: —
```

## Design intent

The supervision system is meant to be:

- **agentic** — supports longer autonomous loops
- **elegant** — uses the repo's existing markdown-first model
- **compatible** — absent policy means old behavior remains
- **bounded** — resource rules and explicit approvals still matter
