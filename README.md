# Compound Mind Framework

[English](#english) | [中文](#中文)

> Compound Mind: Enable AI Agents with self-iteration capabilities

🐢

---

<a name="english"></a>

## English

### Quick Start

**In this tutorial, you will install Compound Mind and verify it's working.**

**Time required**: 5 minutes

**Prerequisites**:
- [ ] OpenClaw installed
- [ ] At least one agent workspace

**What you'll learn**:
- Install the framework
- Verify the flywheel is running
- Understand the directory structure

---

#### Step 1: Clone the repository

```bash
git clone https://github.com/amumulam/compound-mind.git
cd compound-mind
```

**You will see:**

```
Cloning into 'compound-mind'...
remote: Enumerating objects: 50, done.
...
```

---

#### Step 2: Run the installer

```bash
./install.sh
```

The installer will guide you through:
1. Select OpenClaw installation directory
2. Select workspace to install
3. Select model for Cron tasks

**You will see:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🐢 Compound Mind Framework Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Step 1/3] Select OpenClaw installation directory

  ➜ Default: /root/.openclaw
    Custom path...
```

> **Notice**: Use arrow keys to navigate, Enter to select.

---

#### Step 3: Verify installation

Check Cron tasks are created:

```bash
openclaw cron list | grep compound-mind
```

**You should see:**

```
compound-mind-checkpoint   every 6h       ...
compound-mind-compound     cron 0 4 * * * ...
compound-mind-knowledge    cron 30 2 * * 0 ...
compound-mind-optimizer    cron 0 3 * * 0 ...
```

Check directory structure:

```bash
ls docs/ life/ memory/
```

**You should see:**

```
docs/:
solutions  plans  brainstorms

life/:
decisions  motivation

memory/:
2026-03-06.md
```

---

#### Summary

You have installed Compound Mind! The flywheel will now run automatically.

**You learned**:
- How to install the framework
- How to verify Cron tasks
- The directory structure

**Next steps**:
- [Create a plan](#create-a-plan) with `/ce:plan`
- [Capture a solution](#create-a-solution) with `/ce:compound`
- [Learn why Compound Mind exists](#why-compound-mind)

---

### How-to Guides

#### Update Compound Mind

**Goal**: Update to the latest version.

**Applicable scenarios**:
- New version released
- Want to sync latest configurations
- Changed `cronModel` in config file

**Prerequisites**:
- Compound Mind already installed
- Git repository cloned locally

---

```bash
cd compound-mind
./update.sh
```

**What happens**:
1. Checks remote repository for latest version
2. Compares with local version
3. Updates Cron task payloads
4. Syncs directory structure

**Preserved content**:
- `memory/` - Daily logs
- `MEMORY.md` - Long-term memory
- `docs/solutions/` - Your solutions
- `life/decisions/` - Decision logs
- `life/motivation/` - Achievements

---

#### Uninstall Compound Mind

**Goal**: Remove the framework while preserving your data.

**Applicable scenarios**:
- No longer need the framework
- Want to reinstall fresh
- Moving to a different agent

---

```bash
cd compound-mind
./uninstall.sh
```

**What gets removed**:
- Cron tasks (`compound-mind-*`)
- `docs/` directory
- `life/` directory
- Compound Mind rules from `AGENTS.md`

**What is preserved**:
- `memory/` - Your daily logs
- `MEMORY.md` - Your long-term memory

> **Note**: You can reinstall anytime with `./install.sh`

---

#### Change Cron Model

**Goal**: Use a different model for automated tasks.

**Applicable scenarios**:
- Want to use a more capable model
- Want to reduce costs
- Model deprecated

---

**Step 1**: Edit the config file

```bash
nano compound-mind.config.json
```

Change `cronModel`:

```json
{
  "version": "1.0.0",
  "name": "compound-mind",
  "cronModel": "bailian-coding-plan/glm-5"
}
```

**Step 2**: Apply the change

```bash
./update.sh
```

**Verify**:

```bash
openclaw cron list | grep compound-mind-checkpoint
```

You should see the new model in the output.

---

#### Create a Solution

**Goal**: Capture a reusable solution from your work.

**Applicable scenarios**:
- Solved a tricky problem
- Found a better approach
- Learned something valuable

---

In your agent session:

```
/ce:compound
```

**What happens**:
1. Agent reviews recent logs
2. Identifies problem-solution patterns
3. Generates a structured solution document

**Output**: `docs/solutions/YYYY-MM-DD-solution-name.md`

**Example solution**:

```markdown
# bun Install Proxy Timeout

**Problem**: `bun install` fails with proxy timeout.

**Cause**: Default timeout is too short.

**Solution**: Set longer timeout:
\`\`\`bash
bun install --timeout 100000
\`\`\`

**Works with**: bun >= 1.0.0
```

---

### Reference

#### Configuration File

**File**: `compound-mind.config.json`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `version` | string | Yes | Framework version (e.g., "1.0.0") |
| `name` | string | Yes | Framework name ("compound-mind") |
| `cronModel` | string | Yes | Model for Cron tasks |

**Example**:

```json
{
  "version": "1.0.0",
  "name": "compound-mind",
  "cronModel": "bailian-coding-plan/glm-5"
}
```

---

#### Directory Structure

```
workspace/
├── AGENTS.md                    # Operation manual
├── compound-mind.config.json    # Framework config
├── MEMORY.md                    # Long-term memory
├── memory/                      # Daily logs
│   └── YYYY-MM-DD.md
├── docs/                        # CE Plugin output
│   ├── solutions/               # /ce:compound output
│   ├── plans/                   # /ce:plan output
│   └── brainstorms/             # /ce:brainstorm output
├── life/                        # Agent maintained
│   ├── decisions/               # Decision logs
│   └── motivation/              # Achievements/Milestones/Streaks
│       ├── achievements.json
│       ├── milestones.json
│       └── streaks.json
└── work/                        # Working directory (optional)
```

**Directory responsibilities**:

| Directory | Purpose | Retention |
|-----------|---------|-----------|
| `docs/` | Work output | Task-oriented, can rebuild |
| `life/` | Life journey | Growth-oriented, long-term |
| `memory/` | Daily logs | Raw records, permanent |

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

| Command | Output | Description |
|---------|--------|-------------|
| `/ce:plan` | docs/plans/ | Create project plans |
| `/ce:brainstorm` | docs/brainstorms/ | Brainstorm ideas |
| `/ce:compound` | docs/solutions/ | Capture solutions |
| `/ce:review` | - | Multi-perspective code review |
| `/lfg` | - | One-click full workflow |

---

### Explanation

#### What is Compound Mind?

Compound Mind is a framework that enables AI Agents to accumulate experience and self-iterate.

**Core components**:

- **Compound Engineering Plugin**: Workflow capabilities for planning, brainstorming, and capturing solutions
- **ClawIntelligentMemory**: Automatic memory extraction and knowledge management

**What it does**:

1. **Extracts** key information from daily logs
2. **Captures** reusable solutions
3. **Validates** knowledge quality
4. **Maintains** system health

---

#### Why Compound Mind?

**The problem**: AI Agents start fresh each session, losing context and lessons learned.

**The solution**: Compound Mind provides four mechanisms:

| Mechanism | Purpose | Benefit |
|-----------|---------|---------|
| Long-term memory | MEMORY.md persists across sessions | Context preserved |
| Automatic extraction | Flywheel runs every 6 hours | No manual effort |
| Solution library | Structured docs/solutions/ | Knowledge reusable |
| Decision tracking | life/decisions/ | Choices traceable |

**The result**: The agent improves over time through compound interest.

---

#### Core Philosophy

**Restraint over excess, clarity over complexity.**

**Priority principles**:

| Principle | Meaning |
|-----------|---------|
| Don't reinvent the wheel | Use existing solutions |
| Don't add meaningless work | Every line must have value |
| Confirm before implementing | Ask if uncertain |

**Engineering principles**:

1. **Separation of concerns** - One module, one purpose
2. **Minimal intervention** - Don't change what doesn't need changing
3. **Avoid premature optimization** - Solve real problems, not imagined ones
4. **Respect autonomy** - MEMORY.md is the agent's own file
5. **Follow original design intent** - Don't change boundaries for "better"

---

#### How the Flywheel Works

The flywheel is four automated tasks that create compound growth:

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

**Each cycle adds value**:
- More memories captured
- More solutions created
- Better knowledge quality
- Healthier system

---

### Sources

- [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)
- [ClawIntelligentMemory](https://github.com/denda188/ClawIntelligentMemory)
- [Diátaxis Documentation Framework](https://diataxis.fr)

---

### License

MIT

---

🐢 Let the flywheel spin!

---

<a name="中文"></a>

## 中文

### 快速开始

**在本教程中，你将安装 Compound Mind 并验证它是否正常工作。**

**所需时间**：5 分钟

**前置条件**：
- [ ] 已安装 OpenClaw
- [ ] 至少有一个 agent workspace

**你将学到**：
- 如何安装框架
- 如何验证飞轮正在运行
- 理解目录结构

---

#### 步骤 1：克隆仓库

```bash
git clone https://github.com/amumulam/compound-mind.git
cd compound-mind
```

**你将看到**：

```
Cloning into 'compound-mind'...
remote: Enumerating objects: 50, done.
...
```

---

#### 步骤 2：运行安装程序

```bash
./install.sh
```

安装程序将引导你：
1. 选择 OpenClaw 安装目录
2. 选择要安装的 workspace
3. 选择 Cron 任务使用的模型

**你将看到**：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🐢 Compound Mind Framework Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Step 1/3] Select OpenClaw installation directory

  ➜ Default: /root/.openclaw
    Custom path...
```

> **注意**：使用方向键导航，按 Enter 选择。

---

#### 步骤 3：验证安装

检查 Cron 任务是否创建：

```bash
openclaw cron list | grep compound-mind
```

**你应该看到**：

```
compound-mind-checkpoint   every 6h       ...
compound-mind-compound     cron 0 4 * * * ...
compound-mind-knowledge    cron 30 2 * * 0 ...
compound-mind-optimizer    cron 0 3 * * 0 ...
```

检查目录结构：

```bash
ls docs/ life/ memory/
```

**你应该看到**：

```
docs/:
solutions  plans  brainstorms

life/:
decisions  motivation

memory/:
2026-03-06.md
```

---

#### 总结

你已经安装了 Compound Mind！飞轮现在会自动运行。

**你学到了**：
- 如何安装框架
- 如何验证 Cron 任务
- 目录结构

**下一步**：
- [创建计划](#创建计划) 使用 `/ce:plan`
- [捕获方案](#创建方案) 使用 `/ce:compound`
- [了解为什么需要 Compound Mind](#为什么需要-compound-mind)

---

### 操作指南

#### 更新 Compound Mind

**目标**：更新到最新版本。

**适用场景**：
- 发布了新版本
- 想要同步最新配置
- 更改了配置文件中的 `cronModel`

**前置条件**：
- 已安装 Compound Mind
- 已克隆 Git 仓库到本地

---

```bash
cd compound-mind
./update.sh
```

**发生了什么**：
1. 检查远程仓库最新版本
2. 对比本地版本
3. 更新 Cron 任务 payload
4. 同步目录结构

**保留的内容**：
- `memory/` - 每日日志
- `MEMORY.md` - 长期记忆
- `docs/solutions/` - 你的方案
- `life/decisions/` - 决策记录
- `life/motivation/` - 成就

---

#### 卸载 Compound Mind

**目标**：移除框架但保留数据。

**适用场景**：
- 不再需要框架
- 想要重新安装
- 迁移到其他 agent

---

```bash
cd compound-mind
./uninstall.sh
```

**会被删除**：
- Cron 任务（`compound-mind-*`）
- `docs/` 目录
- `life/` 目录
- `AGENTS.md` 中的 Compound Mind 规则

**会保留**：
- `memory/` - 你的每日日志
- `MEMORY.md` - 你的长期记忆

> **注意**：你可以随时用 `./install.sh` 重新安装。

---

#### 更改 Cron 模型

**目标**：使用不同的模型执行自动化任务。

**适用场景**：
- 想使用更强的模型
- 想降低成本
- 模型已弃用

---

**步骤 1**：编辑配置文件

```bash
nano compound-mind.config.json
```

修改 `cronModel`：

```json
{
  "version": "1.0.0",
  "name": "compound-mind",
  "cronModel": "bailian-coding-plan/glm-5"
}
```

**步骤 2**：应用更改

```bash
./update.sh
```

**验证**：

```bash
openclaw cron list | grep compound-mind-checkpoint
```

你应该在输出中看到新模型。

---

#### 创建方案

**目标**：从你的工作中捕获可复用的方案。

**适用场景**：
- 解决了棘手的问题
- 找到了更好的方法
- 学到了有价值的东西

---

在你的 agent 会话中：

```
/ce:compound
```

**发生了什么**：
1. Agent 回顾最近的日志
2. 识别问题-解决模式
3. 生成结构化方案文档

**输出**：`docs/solutions/YYYY-MM-DD-solution-name.md`

**示例方案**：

```markdown
# bun 安装代理超时

**问题**：`bun install` 因代理超时而失败。

**原因**：默认超时时间太短。

**解决方案**：设置更长的超时：
\`\`\`bash
bun install --timeout 100000
\`\`\`

**适用于**：bun >= 1.0.0
```

---

### 参考文档

#### 配置文件

**文件**：`compound-mind.config.json`

| 字段 | 类型 | 必需 | 描述 |
|------|------|------|------|
| `version` | string | 是 | 框架版本（如 "1.0.0"） |
| `name` | string | 是 | 框架名称（"compound-mind"） |
| `cronModel` | string | 是 | Cron 任务使用的模型 |

**示例**：

```json
{
  "version": "1.0.0",
  "name": "compound-mind",
  "cronModel": "bailian-coding-plan/glm-5"
}
```

---

#### 目录结构

```
workspace/
├── AGENTS.md                    # 操作手册
├── compound-mind.config.json    # 框架配置
├── MEMORY.md                    # 长期记忆
├── memory/                      # 每日日志
│   └── YYYY-MM-DD.md
├── docs/                        # CE Plugin 输出
│   ├── solutions/               # /ce:compound 输出
│   ├── plans/                   # /ce:plan 输出
│   └── brainstorms/             # /ce:brainstorm 输出
├── life/                        # Agent 维护
│   ├── decisions/               # 决策记录
│   └── motivation/              # 成就/里程碑/连胜
│       ├── achievements.json
│       ├── milestones.json
│       └── streaks.json
└── work/                        # 工作目录（可选）
```

**目录职责**：

| 目录 | 目的 | 保留期限 |
|------|------|----------|
| `docs/` | 工作产出 | 面向任务，可重建 |
| `life/` | 生命历程 | 面向成长，长期 |
| `memory/` | 每日日志 | 原始记录，永久 |

---

#### Cron 任务

| 任务 | 时间 | 目的 |
|------|------|------|
| `compound-mind-checkpoint` | 每 6 小时 | 提取关键信息 → MEMORY.md |
| `compound-mind-compound` | 每天 04:00 | 创建方案 → docs/solutions/ |
| `compound-mind-knowledge` | 周日 02:30 | 检测过时/重复内容 |
| `compound-mind-optimizer` | 周日 03:00 | 系统维护 |

---

#### CE Plugin 命令

| 命令 | 输出 | 描述 |
|------|------|------|
| `/ce:plan` | docs/plans/ | 创建项目计划 |
| `/ce:brainstorm` | docs/brainstorms/ | 头脑风暴 |
| `/ce:compound` | docs/solutions/ | 捕获方案 |
| `/ce:review` | - | 多视角代码审核 |
| `/lfg` | - | 一键全流程 |

---

### 解释说明

#### 什么是 Compound Mind？

Compound Mind 是一个让 AI Agent 积累经验、自我迭代的框架。

**核心组件**：

- **Compound Engineering Plugin**：工作流能力（计划、头脑风暴、捕获方案）
- **ClawIntelligentMemory**：自动记忆提取和知识管理

**它做什么**：

1. **提取**每日日志中的关键信息
2. **捕获**可复用的方案
3. **验证**知识质量
4. **维护**系统健康

---

#### 为什么需要 Compound Mind？

**问题**：AI Agent 每次会话都是全新的，丢失上下文和经验教训。

**解决方案**：Compound Mind 提供四种机制：

| 机制 | 目的 | 好处 |
|------|------|------|
| 长期记忆 | MEMORY.md 跨会话保留 | 上下文保留 |
| 自动提取 | 飞轮每 6 小时运行 | 无需手动操作 |
| 方案库 | 结构化 docs/solutions/ | 知识可复用 |
| 决策追踪 | life/decisions/ | 选择可追溯 |

**结果**：Agent 通过复利效应持续改进。

---

#### 核心理念

**克制优于过度，清晰优于复杂。**

**优先原则**：

| 原则 | 含义 |
|------|------|
| 不要重新造轮子 | 使用已有方案 |
| 不要添加没有意义的工作 | 每行代码都要有价值 |
| 先确定对了再去做 | 不确定就先问 |

**工程原则**：

1. **职责分离** — 一个模块只做一件事
2. **最小干预** — 能不动的就不动
3. **避免过早优化** — 解决真实问题，不是想象的问题
4. **尊重自主权** — MEMORY.md 是 Agent 自己的文件
5. **遵循原设计意图** — 不为了"更好"而改变边界

---

#### 飞轮如何工作

飞轮是四个自动化任务，创造复利增长：

```
每日日志 → 检查点 → MEMORY.md
                  ↓
           Compound → 方案
                  ↓
           验证 → 质量
                  ↓
           优化 → 健康
                  ↓
              (重复)
```

**每个周期增加价值**：
- 更多记忆被捕获
- 更多方案被创建
- 更好的知识质量
- 更健康的系统

---

### 来源

- [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)
- [ClawIntelligentMemory](https://github.com/denda188/ClawIntelligentMemory)
- [Diátaxis 文档框架](https://diataxis.fr)

---

### 许可证

MIT

---

🐢 让飞轮转起来！