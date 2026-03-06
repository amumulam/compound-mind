# Compound Mind Framework

[中文](./README_CN.md)

> Compound Mind: Enable AI Agents with self-iteration capabilities

🐢

---

### Quick Start

```bash
git clone https://github.com/amumulam/compound-mind.git
cd compound-mind
./install.sh
```

The installer will guide you through workspace and model selection.

---

### How-to Guides

#### Update Compound Mind

```bash
cd compound-mind
./update.sh
```

Checks remote version, updates Cron tasks, syncs directory structure.

**Preserved**: `memory/`, `MEMORY.md`, `docs/solutions/`, `life/decisions/`, `life/motivation/`

---

#### Uninstall Compound Mind

```bash
cd compound-mind
./uninstall.sh
```

Removes Cron tasks, `docs/`, `life/`, AGENTS.md rules. Preserves `memory/` and `MEMORY.md`.

---

#### Change Cron Model

1. Edit `compound-mind.config.json`:

```json
{
  "version": "1.0.0",
  "name": "compound-mind",
  "cronModel": "your-model-here"
}
```

2. Run `./update.sh` to apply.

---

#### Create a Solution

```
/ce:compound
```

Generates a structured solution document in `docs/solutions/`.

---

### Reference

#### Configuration File

`compound-mind.config.json`:

| Field | Type | Description |
|-------|------|-------------|
| `version` | string | Framework version |
| `name` | string | Framework name |
| `cronModel` | string | Model for Cron tasks |

---

#### Directory Structure

```
workspace/
├── AGENTS.md                    # Operation manual
├── compound-mind.config.json    # Framework config
├── MEMORY.md                    # Long-term memory
├── memory/                      # Daily logs
├── docs/                        # CE Plugin output
│   ├── solutions/               # /ce:compound output
│   ├── plans/                   # /ce:plan output
│   └── brainstorms/             # /ce:brainstorm output
├── life/                        # Agent maintained
│   ├── decisions/               # Decision logs
│   └── motivation/              # Achievements/Milestones/Streaks
└── work/                        # Working directory (optional)
```

---

#### Cron Tasks

| Task | Schedule | Purpose |
|------|----------|---------|
| `compound-mind-checkpoint` | Every 6h | Extract key info → MEMORY.md |
| `compound-mind-compound` | Daily 04:00 | Create solutions → docs/solutions/ |
| `compound-mind-knowledge` | Sunday 02:30 | Detect stale/duplicate content |
| `compound-mind-optimizer` | Sunday 03:00 | System maintenance |

---

#### CE Plugin Commands

| Command | Output |
|---------|--------|
| `/ce:plan` | docs/plans/ |
| `/ce:brainstorm` | docs/brainstorms/ |
| `/ce:compound` | docs/solutions/ |
| `/ce:review` | Multi-perspective code review |
| `/lfg` | One-click full workflow |

---

### Explanation

#### What is Compound Mind?

A framework that enables AI Agents to accumulate experience and self-iterate through:

- **Long-term memory** (MEMORY.md): Curated knowledge that persists across sessions
- **Automatic extraction**: Flywheel tasks extract insights from daily logs
- **Solution library**: Structured, reusable solutions in `docs/solutions/`
- **Decision tracking**: Every major decision logged and traceable

---

#### Core Philosophy

**Restraint over excess, clarity over complexity.**

| Principle | Meaning |
|-----------|---------|
| Don't reinvent the wheel | Use existing solutions |
| Don't add meaningless work | Every line must have value |
| Confirm before implementing | Ask if uncertain |

---

#### How the Flywheel Works

```
Daily Logs → Checkpoint → MEMORY.md
                  ↓
           Compound → Solutions
                  ↓
           Validation → Quality
                  ↓
           Optimization → Health
                  ↓
                (repeat)
```

Each cycle adds value through compound interest.

---

### Sources

- [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)
- [ClawIntelligentMemory](https://github.com/denda188/ClawIntelligentMemory)

---

### License

MIT

---

🐢 Let the flywheel spin!