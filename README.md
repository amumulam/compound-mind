# Compound Mind Framework

[English](#english) | [中文](#中文)

> Compound Mind: Enable AI Agents with self-iteration capabilities

🐢

---

<a name="english"></a>

## English

### Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/amumulam/compound-mind.git
cd compound-mind

# 2. Run the installer
./install.sh

# 3. Follow the interactive prompts
# - Select OpenClaw installation directory
# - Select workspace to install
# - Select model for Cron tasks

# Done! The flywheel will start automatically.
```

---

### Tutorials

#### Getting Started with Compound Mind

**What you'll learn**: Install and configure Compound Mind for your AI Agent.

**Prerequisites**:
- OpenClaw installed
- At least one agent workspace

**Steps**:

1. **Clone the repository**
   ```bash
   git clone https://github.com/amumulam/compound-mind.git
   cd compound-mind
   ```

2. **Run the installer**
   ```bash
   ./install.sh
   ```

3. **Select your workspace**
   - Use arrow keys to navigate
   - Press Enter to select

4. **Choose your model**
   - Models are read from `openclaw.json`
   - Select the model for Cron tasks

5. **Verify installation**
   ```bash
   # Check Cron tasks
   openclaw cron list | grep compound-mind

   # Check directory structure
   ls docs/ life/ memory/
   ```

**What's next?** The flywheel tasks will run automatically:
- Checkpoint extraction (every 6 hours)
- Compound extraction (daily at 04:00)
- Knowledge validation (Sunday 02:30)
- Nighttime optimizer (Sunday 03:00)

---

### How-to Guides

#### Update Compound Mind

**Goal**: Update to the latest version of Compound Mind.

```bash
cd compound-mind
./update.sh
```

The update script will:
- Check remote repository for latest version
- Compare with local version
- Update Cron task payloads
- Sync directory structure

**Preserved content**: memory/, MEMORY.md, docs/solutions/, life/decisions/, life/motivation/

---

#### Uninstall Compound Mind

**Goal**: Remove Compound Mind while preserving your data.

```bash
cd compound-mind
./uninstall.sh
```

**Removed**: Cron tasks, docs/, life/, AGENTS.md rules

**Preserved**: memory/, MEMORY.md

---

#### Change Cron Model

**Goal**: Use a different model for Cron tasks.

1. Edit `compound-mind.config.json`:
   ```json
   {
     "version": "1.0.0",
     "name": "compound-mind",
     "cronModel": "your-model-here"
   }
   ```

2. Run update to apply:
   ```bash
   ./update.sh
   ```

---

#### Create a Solution Document

**Goal**: Capture a reusable solution using `/ce:compound`.

```bash
# In your agent session
/ce:compound
```

The agent will:
1. Review recent logs
2. Identify problem-solution patterns
3. Generate a structured solution document in `docs/solutions/`

---

### Reference

#### Configuration File

`compound-mind.config.json`:

| Field | Type | Description |
|-------|------|-------------|
| `version` | string | Framework version (e.g., "1.0.0") |
| `name` | string | Framework name |
| `cronModel` | string | Model used for Cron tasks |

---

#### Directory Structure

```
workspace/
├── AGENTS.md              # Operation manual
├── compound-mind.config.json  # Framework config
├── MEMORY.md              # Long-term memory
├── memory/                # Daily logs
├── docs/                  # CE Plugin output
│   ├── solutions/         # /ce:compound output
│   ├── plans/             # /ce:plan output
│   └── brainstorms/       # /ce:brainstorm output
├── life/                  # Agent maintained
│   ├── decisions/         # Decision logs
│   └── motivation/        # Achievements/Milestones/Streaks
└── work/                  # Working directory (optional)
```

---

#### Cron Tasks

| Task | Schedule | Purpose |
|------|----------|---------|
| `compound-mind-checkpoint` | Every 6h | Extract key info from logs → MEMORY.md |
| `compound-mind-compound` | Daily 04:00 | Create reusable solutions → docs/solutions/ |
| `compound-mind-knowledge` | Sunday 02:30 | Detect stale/isolated/duplicate content |
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

Compound Mind is a framework that enables AI Agents to accumulate experience and self-iterate. It combines:

- **Compound Engineering Plugin**: Workflow capabilities for planning, brainstorming, and capturing solutions
- **ClawIntelligentMemory**: Automatic memory extraction and knowledge management

---

#### Why Compound Mind?

**Problem**: AI Agents start fresh each session, losing context and lessons learned.

**Solution**: Compound Mind provides:

1. **Long-term memory** (MEMORY.md): Curated knowledge that persists across sessions
2. **Automatic extraction**: Flywheel tasks that continuously extract insights from daily logs
3. **Solution library**: Structured, reusable solutions in `docs/solutions/`
4. **Decision tracking**: Every major decision is logged and traceable

**Result**: The agent improves over time through compound interest.

---

#### Core Philosophy

**Restraint over excess, clarity over complexity.**

| Principle | Description |
|-----------|-------------|
| Don't reinvent the wheel | Use existing solutions |
| Don't add meaningless work | Every line of code must have value |
| Confirm before implementing | Ask if uncertain |

---

#### Engineering Principles

1. **Separation of concerns**: One module, one purpose
2. **Minimal intervention**: Don't change what doesn't need changing
3. **Avoid premature optimization**: Solve real problems, not imagined ones
4. **Respect autonomy**: MEMORY.md is the agent's own file
5. **Follow original design intent**: Don't change boundaries for "better"

---

### Sources

- [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)
- [ClawIntelligentMemory](https://github.com/denda188/ClawIntelligentMemory)

---

### License

MIT

---

🐢 Let the flywheel spin!

---

<a name="中文"></a>

## 中文

### 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/amumulam/compound-mind.git
cd compound-mind

# 2. 运行安装脚本
./install.sh

# 3. 按照交互提示操作
# - 选择 OpenClaw 安装目录
# - 选择要安装的 workspace
# - 选择 Cron 任务使用的模型

# 完成！飞轮将自动开始运行。
```

---

### 教程

#### Compound Mind 入门

**学习目标**: 为你的 AI Agent 安装和配置 Compound Mind。

**前置条件**:
- 已安装 OpenClaw
- 至少有一个 agent workspace

**步骤**:

1. **克隆仓库**
   ```bash
   git clone https://github.com/amumulam/compound-mind.git
   cd compound-mind
   ```

2. **运行安装脚本**
   ```bash
   ./install.sh
   ```

3. **选择 workspace**
   - 使用方向键导航
   - 按 Enter 选择

4. **选择模型**
   - 模型列表从 `openclaw.json` 读取
   - 选择用于 Cron 任务的模型

5. **验证安装**
   ```bash
   # 检查 Cron 任务
   openclaw cron list | grep compound-mind

   # 检查目录结构
   ls docs/ life/ memory/
   ```

**下一步?** 飞轮任务将自动运行:
- 检查点提取（每 6 小时）
- Compound 提取（每天 04:00）
- 知识验证（周日 02:30）
- 夜间优化（周日 03:00）

---

### 操作指南

#### 更新 Compound Mind

**目标**: 更新到最新版本。

```bash
cd compound-mind
./update.sh
```

更新脚本会:
- 检查远程仓库最新版本
- 对比本地版本
- 更新 Cron 任务 payload
- 同步目录结构

**保留内容**: memory/, MEMORY.md, docs/solutions/, life/decisions/, life/motivation/

---

#### 卸载 Compound Mind

**目标**: 移除框架但保留数据。

```bash
cd compound-mind
./uninstall.sh
```

**删除**: Cron 任务, docs/, life/, AGENTS.md 规则

**保留**: memory/, MEMORY.md

---

#### 更改 Cron 模型

**目标**: 使用不同的模型执行 Cron 任务。

1. 编辑 `compound-mind.config.json`:
   ```json
   {
     "version": "1.0.0",
     "name": "compound-mind",
     "cronModel": "你的模型"
   }
   ```

2. 运行更新以应用:
   ```bash
   ./update.sh
   ```

---

#### 创建解决方案文档

**目标**: 使用 `/ce:compound` 捕获可复用的解决方案。

```bash
# 在 agent 会话中
/ce:compound
```

Agent 会:
1. 回顾最近的日志
2. 识别问题-解决模式
3. 在 `docs/solutions/` 生成结构化方案文档

---

### 参考文档

#### 配置文件

`compound-mind.config.json`:

| 字段 | 类型 | 描述 |
|------|------|------|
| `version` | string | 框架版本（如 "1.0.0"） |
| `name` | string | 框架名称 |
| `cronModel` | string | Cron 任务使用的模型 |

---

#### 目录结构

```
workspace/
├── AGENTS.md              # 操作手册
├── compound-mind.config.json  # 框架配置
├── MEMORY.md              # 长期记忆
├── memory/                # 每日日志
├── docs/                  # CE Plugin 输出
│   ├── solutions/         # /ce:compound 输出
│   ├── plans/             # /ce:plan 输出
│   └── brainstorms/       # /ce:brainstorm 输出
├── life/                  # Agent 维护
│   ├── decisions/         # 决策记录
│   └── motivation/        # 成就/里程碑/连胜
└── work/                  # 工作目录（可选）
```

---

#### Cron 任务

| 任务 | 时间 | 目的 |
|------|------|------|
| `compound-mind-checkpoint` | 每 6 小时 | 从日志提取关键信息 → MEMORY.md |
| `compound-mind-compound` | 每天 04:00 | 创建可复用方案 → docs/solutions/ |
| `compound-mind-knowledge` | 周日 02:30 | 检测过时/孤立/重复内容 |
| `compound-mind-optimizer` | 周日 03:00 | 系统维护 |

---

#### CE Plugin 命令

| 命令 | 输出 |
|------|------|
| `/ce:plan` | docs/plans/ |
| `/ce:brainstorm` | docs/brainstorms/ |
| `/ce:compound` | docs/solutions/ |
| `/ce:review` | 多视角代码审核 |
| `/lfg` | 一键全流程 |

---

### 解释说明

#### 什么是 Compound Mind？

Compound Mind 是一个让 AI Agent 积累经验、自我迭代的框架。它结合了:

- **Compound Engineering Plugin**: 工作流能力（计划、头脑风暴、捕获方案）
- **ClawIntelligentMemory**: 自动记忆提取和知识管理

---

#### 为什么需要 Compound Mind？

**问题**: AI Agent 每次会话都是全新的，丢失上下文和经验教训。

**解决方案**: Compound Mind 提供:

1. **长期记忆** (MEMORY.md): 跨会话保留的知识
2. **自动提取**: 飞轮任务持续从日志中提取洞察
3. **方案库**: `docs/solutions/` 中结构化、可复用的方案
4. **决策追踪**: 每个重要决策都被记录和追溯

**结果**: Agent 通过复利效应持续改进。

---

#### 核心理念

**克制优于过度，清晰优于复杂。**

| 原则 | 描述 |
|------|------|
| 不要重新造轮子 | 使用已有方案 |
| 不要添加没有意义的工作 | 每行代码都要有价值 |
| 先确定对了再去做 | 不确定就先问 |

---

#### 工程原则

1. **职责分离**: 一个模块只做一件事
2. **最小干预**: 能不动的就不动
3. **避免过早优化**: 解决真实问题，不是想象的问题
4. **尊重自主权**: MEMORY.md 是 Agent 自己的文件
5. **遵循原设计意图**: 不为了"更好"而改变边界

---

### 来源

- [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)
- [ClawIntelligentMemory](https://github.com/denda188/ClawIntelligentMemory)

---

### 许可证

MIT

---

🐢 让飞轮转起来！