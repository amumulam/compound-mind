# Compound Memory Framework

融合 Compound Engineering Plugin 和 ClawIntelligentMemory 的开箱即用框架。

## 设计理念

**核心原则**：
1. **不修改上游** - CE Plugin 保持原样，方便追踪更新
2. **配置分离** - 自定义配置独立存放
3. **符号链接桥接** - 用软连接打通两者
4. **开箱即用** - 最小配置即可启动

## 架构图

```
┌─────────────────────────────────────────────────────────────┐
│                     OpenClaw Runtime                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ CE Plugin (上游，不修改)                               │   │
│  │ ~/.openclaw/extensions/compound-engineering/          │   │
│  │                                                       │   │
│  │  • /ce:plan    → 研究规划 (5 research agents)         │   │
│  │  • /ce:work    → 执行工作                             │   │
│  │  • /ce:review  → 多视角审核 (15 review agents)        │   │
│  │  • /ce:compound → 沉淀到 docs/solutions/              │   │
│  │  • /lfg        → 一键全流程                           │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         │                                    │
│                         │ 符号链接                           │
│                         ▼                                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Workspace (个人数据 + 智能记忆)                        │   │
│  │ ~/.openclaw/workspace-baba/                           │   │
│  │                                                       │   │
│  │  docs/solutions/ → life/archives/solutions/ (软链接) │   │
│  │                                                       │   │
│  │  ├── MEMORY.md          # 精选记忆                    │   │
│  │  ├── memory/            # 每日日志                    │   │
│  │  ├── life/              # 长期归档                    │   │
│  │  │   ├── archives/                                    │   │
│  │  │   │   ├── solutions/  ← CE Compound 输出          │   │
│  │  │   │   ├── weekly/      # 周报                     │   │
│  │  │   │   └── daily/       # 日志归档                 │   │
│  │  │   ├── decisions/      # 决策日志                  │   │
│  │  │   └── motivation/     # 成就系统                  │   │
│  │  │                                                   │   │
│  │  └── para-system/       # 定时任务                   │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         │                                    │
│                         │ Cron 触发                          │
│                         ▼                                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ 智能记忆系统 (ClawIntelligentMemory)                   │   │
│  │                                                       │   │
│  │  • 检查点提取 (每6h)  → 从日志提取关键信息            │   │
│  │  • 模式发现 (每周日)  → 分析规律                      │   │
│  │  • 知识验证 (每周日)  → 检测过时/冲突                 │   │
│  │  • 夜间优化 (每周日)  → 系统健康维护                  │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## 数据流

```
任务开始
    │
    ├─→ /ce:plan ─→ 研究规划
    │       │
    │       └─→ memory_search 检索历史经验
    │
    ├─→ /ce:work ─→ 执行工作
    │
    ├─→ /ce:review ─→ 15 视角审核
    │
    └─→ /ce:compound ─→ 沉淀解决方案
            │
            └─→ docs/solutions/ (软链接到 life/archives/solutions/)
                    │
                    └─→ 检查点提取 (每6h)
                            │
                            ├─→ 更新 MEMORY.md
                            ├─→ 更新 achievements.json
                            └─→ 记录决策日志
```

## 安装步骤

### 1. 安装 CE Plugin

```bash
# 安装 bun (如果没有)
curl -fsSL https://bun.sh/install | bash

# 安装 CE Plugin 到 OpenClaw
bunx @every-env/compound-plugin install compound-engineering --to openclaw
```

### 2. 创建符号链接

```bash
cd ~/.openclaw/workspace-baba
mkdir -p docs
ln -s ../life/archives/solutions docs/solutions
```

### 3. 配置 Cron 任务

已配置完成：
- 检查点提取：每 6 小时
- 模式发现：每周日 02:00
- 知识验证：每周日 02:30
- 夜间优化：每周日 03:00

### 4. 更新 CE Plugin

```bash
# 追踪上游更新
bunx @every-env/compound-plugin install compound-engineering --to openclaw

# 或用 ClawHub 更新（如果已发布）
clawhub update compound-engineering
```

## 目录结构

```
~/.openclaw/
│
├── extensions/
│   └── compound-engineering/     # CE Plugin (上游，不修改)
│       ├── SKILL.md
│       ├── agents/               # 29 个 agents
│       ├── commands/             # 22 个命令
│       └── skills/               # 20 个 skills
│
└── workspace-baba/               # 个人 workspace
    ├── docs/
    │   └── solutions/ → ../life/archives/solutions/  # 软链接
    │
    ├── MEMORY.md                 # 精选记忆
    ├── memory/                   # 每日日志
    ├── life/
    │   ├── archives/
    │   │   ├── solutions/        # CE Compound 输出
    │   │   ├── weekly/           # 周报
    │   │   └── daily/            # 日志归档
    │   ├── decisions/            # 决策日志
    │   └── motivation/           # 成就系统
    │
    ├── para-system/              # 定时任务配置
    └── todos/                    # 待办
```

## 关键设计决策

| 决策 | 选择 | 理由 |
|------|------|------|
| CE Plugin 安装位置 | `extensions/` | OpenClaw 标准路径，便于追踪更新 |
| 是否修改 CE Plugin | 否 | 保持与上游同步 |
| Compound 输出位置 | `life/archives/solutions/` | 软链接桥接 |
| Cron 配置方式 | OpenClaw cron | 集成度高，自动报告 |
| 决策日志 | 独立目录 | CE 没有，补充 |

## 版本兼容性

- CE Plugin: v2.38.x
- OpenClaw: latest
- 维护者: 巴巴 🐢

---

**创建时间**: 2026-03-03
**作者**: 巴巴（架构师）