---
name: customize
description: >-
  Configure the project's skill stack and supervision preferences. Reads the
  curated registry in `skillpacks/skill_dictionary.yaml`, asks a short preset-first set of
  questions about workflow, dependency tolerance, autonomy style, and resource
  policy, then writes or updates `.co-researcher/skills.yaml`. Trigger phrases:
  "customize my stack", "configure skillpacks", "set up my skills",
  "choose presets", "configure supervision and packs", "personalize this
  project".
---

# Customize

Use this skill when the user wants to choose a preferred stack for the current project instead of manually copying many external skills.

---

## Goals

`customize` should:

1. Read the curated registry in `skillpacks/skill_dictionary.yaml`.
2. Recommend packs and subsets by **capability**, not just by repo name.
3. Configure supervision policy alongside skill selection.
4. Write the result to `.co-researcher/skills.yaml`.
5. Keep the result easy to read and edit manually.

If `.co-researcher/skills.yaml` is absent, create it. If present, preserve unrelated fields where possible.

Use `templates/skills.yaml.template` as the starting shape when you need to create the file from scratch.

When expanding a preset into the full file, merge: preset's `packs` and `supervision.mode`/`risk_profile` take precedence; all other fields (`preferences`, full `supervision` subtree) are filled from template defaults unless the user explicitly changed them.

---

## Inputs

### Registry sources

Read:

- `skillpacks/skill_dictionary.yaml`
- `skillpacks/presets/*.yaml`

These are the source of truth for available packs, curated subsets, and preset bundles.

### Existing project state

If present, also read:

- `.co-researcher/skills.yaml`
- `RESEARCH.md`

Use them to infer whether the project is literature-heavy, experiment-heavy, publication-focused, or still exploratory.

---

## Interaction model

Use a short preset-first flow. Ask all questions together when possible.

### Required questions

1. **Workflow type**
   - `core-only`
   - `low-dependency`
   - `literature-heavy`
   - `experiment-heavy`
   - `academic-rigor`
   - `balanced`
   - `custom`

2. **Dependency tolerance**
   - minimal
   - balanced
   - best-in-class even if heavier

3. **Autonomy style**
   - manual
   - checkpointed
   - autonomous
   - wild

4. **Resource policy**
   - local only
   - APIs allowed
   - remote compute allowed

5. **Preference knobs**
   - minimize overlap?
   - prefer subset installs?
   - allow experimental packs?

### Existing config editing

If `.co-researcher/skills.yaml` already exists, begin by asking:

- keep current selection and only adjust supervision?
- adjust packs only?
- adjust both?

---

## Recommendation rules

### Capability-first mapping

- If the user wants stronger literature search/synthesis, prioritize `aris/research-lit`, `aris/research-refine`, `feynman/alpha-research`, or `academic-research-skills/deep-research`.
- If the user wants stronger experiment planning, prioritize `aris/experiment-plan`.
- If the user wants claim/interpretation checking, prioritize `aris/result-to-claim`.
- If the user wants academic rigor in writing/review, prioritize `academic-paper-reviewer`.
- If the user wants compute-heavy execution, surface NanoResearch as a niche/heavy option rather than a default.

### Dependency warnings

- `feynman/alpha-research` requires AlphaXiv authentication (`feynman alpha login`). Always surface this when recommending `literature-heavy` or any feynman skill.
- `nanoresearch/project-experiment` requires local GPU or cluster access. Always surface this when recommending `experiment-heavy` with NanoResearch.

### Default posture

- Always keep `core` enabled.
- Prefer curated subsets over full-pack installs.
- Avoid recommending heavy overlapping packs unless the user explicitly wants them.

### Preset choice

Prefer a preset when the user's answers fit one cleanly. Fall back to custom pack selection only when necessary.

`balanced` should map to the `balanced` preset in `skillpacks/presets/balanced.yaml`.

---

## Output file

Write or update:

```text
.co-researcher/skills.yaml
```

Expected shape:

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

---

## Required behavior after recommendation

Before writing the file:

1. Show the recommended preset or custom stack.
2. Show selected packs and selected skills.
3. Show supervision mode and any notable approval/resource settings.
4. Explain tradeoffs briefly.
5. Ask for confirmation.

After writing the file:

1. Tell the user where the config was written.
2. Summarize the chosen stack.
3. Mention that the file is intended to be hand-editable.

---

## Constraints

- Do not install external skills silently.
- Do not mutate `skillpacks/skill_dictionary.yaml`; that belongs to `evolve`.
- Do not recommend full-pack imports unless the user clearly asks for them.
- Prefer simple, project-local configuration over hidden session-only state.
