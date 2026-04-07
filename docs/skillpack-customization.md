# Skillpack Registry and Customization

Oh My Co-Researcher uses a **lean core + curated registry** model.

- The built-in core (`research`, `experiment`, `review`, `write`, `supervision`, `customize`, `evolve`) is always the base.
- External packs are tracked in `skillpacks/skill_dictionary.yaml` as curated donors or overlays.
- Project-specific choices live in `.co-researcher/skills.yaml`.

## Files

### Shared registry

```text
skillpacks/skill_dictionary.yaml
skillpacks/presets/*.yaml
```

The registry records, for each pack:

- what it is best at
- its overlap with core
- dependency burden
- recommended role (`base`, `donor`, `overlay`, `niche`, `experimental`)
- recommended subset of high-value skills

### Project-local config

```text
.co-researcher/skills.yaml
```

This file stores the current project's:

- chosen preset or custom stack
- enabled packs and selected skills
- preference knobs
- supervision defaults

To bootstrap a project-local config manually, copy:

```text
templates/skills.yaml.template
```

to:

```text
.co-researcher/skills.yaml
```

## How to configure

Use `customize` when you want the repo to recommend a stack instead of manually stitching many skills together.

The flow is preset-first:

1. choose a workflow profile
2. choose dependency tolerance
3. choose autonomy style
4. choose resource policy
5. confirm the recommended stack

## Precedence

There are two policy layers:

1. `RESEARCH.md` `## Supervision Policy` — active runtime policy
2. `.co-researcher/skills.yaml` `supervision` — project-local defaults written by `customize`

When both exist, `RESEARCH.md` wins. The project-local config is the default preference layer; `RESEARCH.md` is the live working-state layer.

## Example `.co-researcher/skills.yaml`

```yaml
version: 1
profile: balanced

selection:
  preset: balanced

enabled_packs:
  core:
    enabled: true
  aris:
    enabled: true
    mode: subset
    selected_skills:
      - research-lit
      - research-refine
      - experiment-plan
      - result-to-claim

preferences:
  minimize_overlap: true
  prefer_low_dependency: true
  prefer_subset_installs: true
  allow_experimental_packs: false

supervision:
  mode: checkpointed
  risk_profile: balanced
  approval_policy:
    install_new_skills: ask
    update_registry: ask
    modify_config: ask
    launch_experiments: ask
    use_external_api: ask_first_use
    run_long_review_loops: ask
    create_commits: ask
  resource_policy:
    local_only: false
    cloud_allowed: false
    cluster_allowed: false
  budget_policy:
    enabled: true
    api_budget_level: medium
  execution_limits:
    max_review_rounds: 2
    require_confirmation_for_new_pack_imports: true
```

## Roles

### `evolve`

`evolve` owns the shared registry.

It should:

- assess new packs
- judge necessity and compatibility
- refresh existing entries
- maintain recommended subsets and presets

### `customize`

`customize` owns project personalization.

It should:

- read the registry
- recommend a preset or custom stack
- configure supervision policy
- write `.co-researcher/skills.yaml`

## Design principles

- choose by capability, not repo sprawl
- prefer subsets over full-pack installs
- keep the config hand-editable
- keep supervision policy alongside stack selection
- preserve backward compatibility when `.co-researcher/skills.yaml` is absent
