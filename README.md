![Compound Mind Banner](./docs/assets/banner.jpg)

# Compound Mind

> Make AI Agents grow with every task.

🌐 [中文文档](README_ZH.md)

![Version](https://img.shields.io/badge/version-v1.6.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![OpenClaw](https://img.shields.io/badge/OpenClaw-Compatible-orange)
![Last Updated](https://img.shields.io/github/last-commit/amumulam/compound-mind)

---

## 📖 Introduction

**Compound Mind** is an automated experience sedimentation system for OpenClaw agents. It transforms daily logs into reusable solutions through scheduled tasks, enabling compound growth of knowledge over time.

### Core Philosophy

> Improve 1% every day, grow 37x in a year.

Compound Mind implements the concept of **compound growth** for AI agent knowledge:
- 📝 **Daily logs** capture raw experiences
- 💡 **Automated extraction** distills reusable solutions
- 📚 **Structured storage** builds a knowledge base
- 🔄 **Continuous iteration** enables self-improvement

---

## ✨ Features

### Flywheel Tasks

| Task | Frequency | Description |
|------|-----------|-------------|
| 🔄 **Checkpoint** | Every 6 hours | Extract key insights from logs to MEMORY.md |
| 💡 **Compound** | Daily 04:00 | Auto-generate reusable solutions from logs |
| 🔍 **Knowledge Validation** | Weekly Sunday 02:30 | Check for knowledge silos and duplicates |
| 🛠️ **Optimizer** | Weekly Sunday 03:00 | System health maintenance (Git commits, cleanup) |
| 📋 **Plan Check** | Daily 21:00 | Ensure long-term tasks have plan files |
| 📊 **Monitor** | Daily 22:00 | Framework health monitoring & reports |

### Automated Capabilities

- ✅ **Auto Recording** - Daily logs automatically appended to MEMORY.md
- ✅ **Auto Sedimentation** - Solutions extracted to `docs/solutions/`
- ✅ **Auto Validation** - Weekly knowledge quality checks
- ✅ **Auto Monitoring** - Daily health reports generated

---

## 🚀 Quick Start

### Prerequisites

- OpenClaw installed and configured
- Access to OpenClaw Cron functionality

### Installation

```bash
# Clone the repository
cd /root/.openclaw/workspace-baba
git clone https://github.com/amumulam/compound-mind.git

# Run installation script
cd compound-mind
chmod +x install.sh && ./install.sh
```

### Verification

```bash
# Check task status
openclaw cron list | grep compound-mind

# View observation reports
cat life/observation-reports/$(date +%Y-%m-%d).md

# Check health status
cat life/health-state.json
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Compound Mind Flywheel               │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌─────────┐    ┌─────────┐    ┌─────────┐           │
│   │Checkpoint│ →  │Compound │ →  │Knowledge│           │
│   │ 每 6 小时  │    │ 每天 04:00│    │ 每周日   │           │
│   └─────────┘    └─────────┘    └─────────┘           │
│        ↓                                  ↓            │
│   记忆沉淀                            质量验证          │
│                                                         │
│   ┌─────────┐    ┌─────────┐                           │
│   │Optimizer│ ←  │ Monitor │                           │
│   │ 每周日   │    │ 每天 22:00│                           │
│   └─────────┘    └─────────┘                           │
│        ↓                                  ↓            │
│   健康维护                            观测报告          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Data Flow

```
Daily Logs → Checkpoint → MEMORY.md
                ↓
        Compound Extraction
                ↓
        docs/solutions/
                ↓
        Knowledge Validation
                ↓
        Health Reports
```

---

## 📂 Directory Structure

```
compound-mind/
├── README.md                      # English documentation
├── README_ZH.md                   # Chinese documentation
├── compound-mind.config.json      # Framework configuration
├── CHANGELOG.md                   # Version history
├── install.sh                     # Installation script
├── update.sh                      # Update script
├── rollback.sh                    # Rollback script
├── scripts/
│   ├── validate_config.py         # Configuration validation
│   ├── create_cron_tasks.py       # Task creation
│   ├── verify_tasks.py            # Task verification
│   └── migrate_cron_tasks.py      # Task migration
├── docs/
│   ├── assets/                    # Images and banners
│   ├── plans/                     # Plan files
│   ├── solutions/                 # Reusable solutions
│   └── brainstorms/               # Brainstorming notes
├── life/
│   ├── decisions/                 # Decision records
│   ├── health-state.json          # Health status
│   ├── motivation/                # Achievement records
│   └── observation-reports/       # Observation reports
└── memory/                        # Daily logs
```

---

## 📊 Live Demo

### Sample Observation Report

```markdown
## Compound Mind Monitor Report
Date: 2026-03-12

### Task Status
| Task | Status | Last Run |
|------|--------|----------|
| Checkpoint | ✅ OK | 2 hours ago |
| Compound | ✅ OK | 8 hours ago |
| Knowledge | ✅ OK | 5 days ago |
| Optimizer | ✅ OK | 5 days ago |
| Monitor | ✅ OK | Just now |

### Health Score: 100%
All systems operational.
```

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Report Issues** - Found a bug? Open an issue
2. **Submit PRs** - Have a fix? Send a pull request
3. **Share Solutions** - Add your solutions to `docs/solutions/`
4. **Improve Docs** - Help translate or improve documentation

### Development Setup

```bash
# Fork and clone
git clone https://github.com/amumulam/compound-mind.git
cd compound-mind

# Install dependencies
npm install

# Run tests
./test-framework.sh
```

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🌟 Acknowledgments

- Built on [OpenClaw](https://openclaw.ai)
- Inspired by compound growth principles
- Architecture design inspired by [Compound Engineering Plugin](https://github.com/openclaw/compound-engineering-plugin)
- Memory system design inspired by [Claw Intelligent Memory](https://github.com/openclaw/claw-intelligent-memory)
- Community contributions from OpenClaw users

---

![Made with ❤️ for OpenClaw Community](https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-red)
