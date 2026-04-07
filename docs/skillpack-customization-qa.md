# Skillpack Customization QA Notes

This note records the manual QA that was run for the implementation-start scope of the skillpack registry and customization model.

## Project-local install

Command executed:

```bash
bash install.sh
```

Observed output included:

```text
✓ Skills → <temp>/proj/.claude/skills
✓ Templates → <temp>/proj/templates
✓ Skillpacks → <temp>/proj/skillpacks
✓ CLAUDE.md → <temp>/proj/CLAUDE.md
```

Verified created paths:

- `.claude/skills/research/SKILL.md`
- `templates/RESEARCH.md.template`
- `templates/skills.yaml.template`
- `skillpacks/skill_dictionary.yaml`
- `CLAUDE.md`

Verified bootstrap config creation:

```bash
mkdir -p .co-researcher
cp templates/skills.yaml.template .co-researcher/skills.yaml
```

Observed config head:

```yaml
version: 1
profile: balanced

selection:
  preset: balanced
```

## Global install

Command executed:

```bash
bash install.sh --global
```

Observed output included:

```text
✓ Skills → <temp-home>/.claude/skills
✓ Templates → <temp-home>/.claude/co-researcher/templates
✓ Skillpacks → <temp-home>/.claude/co-researcher/skillpacks
✓ CLAUDE.md → <temp-home>/.claude/co-researcher/CLAUDE.md
```

Verified created paths:

- `~/.claude/skills/research/SKILL.md`
- `~/.claude/co-researcher/templates/RESEARCH.md.template`
- `~/.claude/co-researcher/templates/skills.yaml.template`
- `~/.claude/co-researcher/skillpacks/skill_dictionary.yaml`
- `~/.claude/co-researcher/CLAUDE.md`

## Integration checks covered by repo content

- `customize` points to `templates/skills.yaml.template` as the starting shape for `.co-researcher/skills.yaml`.
- `research` documents precedence: `RESEARCH.md` supervision policy overrides `.co-researcher/skills.yaml`, and presets are starting recommendations only.
- `docs/agent-setup.md` now distinguishes project-local and global registry locations.
