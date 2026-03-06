# Compound Mind Framework

[English](./README.md) | 中文

> 复利心智：让 AI Agent 拥有自我迭代的能力

🐢

---

## 快速开始

```bash
git clone https://github.com/amumulam/compound-mind.git
cd compound-mind
./install.sh
```

安装程序会引导你选择 workspace 和模型。

---

## 操作指南

### 更新 Compound Mind

```bash
cd compound-mind
./update.sh
```

检查远程版本，更新 Cron 任务，同步目录结构。

**保留内容**：`memory/`、`MEMORY.md`、`docs/solutions/`、`life/decisions/`、`life/motivation/`

---

### 卸载 Compound Mind

```bash
cd compound-mind
./uninstall.sh
```

删除 Cron 任务、`docs/`、`life/`、AGENTS.md 规则。保留 `memory/` 和 `MEMORY.md`。

---

### 更改 Cron 模型

1. 编辑 `compound-mind.config.json`：

```json
{
  "version": "1.0.0",
  "name": "compound-mind",
  "cronModel": "你的模型"
}
```

2. 运行 `./update.sh` 应用更改。

---

### 创建方案

```
/ce:compound
```

在 `docs/solutions/` 生成结构化方案文档。

---

## 参考文档

### 配置文件

`compound-mind.config.json`：

| 字段 | 类型 | 描述 |
|------|------|------|
| `version` | string | 框架版本 |
| `name` | string | 框架名称 |
| `cronModel` | string | Cron 任务使用的模型 |

---

### 目录结构

```
workspace/
├── AGENTS.md                    # 操作手册
├── compound-mind.config.json    # 框架配置
├── MEMORY.md                    # 长期记忆
├── memory/                      # 每日日志
├── docs/                        # CE Plugin 输出
│   ├── solutions/               # /ce:compound 输出
│   ├── plans/                   # /ce:plan 输出
│   └── brainstorms/             # /ce:brainstorm 输出
├── life/                        # Agent 维护
│   ├── decisions/               # 决策记录
│   └── motivation/              # 成就/里程碑/连胜
```

---

### Cron 任务

| 任务 | 时间 | 目的 |
|------|------|------|
| `compound-mind-checkpoint` | 每 6 小时 | 提取关键信息 → MEMORY.md |
| `compound-mind-compound` | 每天 04:00 | 创建方案 → docs/solutions/ |
| `compound-mind-knowledge` | 周日 02:30 | 检测过时/重复内容 |
| `compound-mind-optimizer` | 周日 03:00 | 系统维护 |

---

### CE Plugin 命令

| 命令 | 输出 |
|------|------|
| `/ce:plan` | docs/plans/ |
| `/ce:brainstorm` | docs/brainstorms/ |
| `/ce:compound` | docs/solutions/ |
| `/ce:review` | 多视角代码审核 |
| `/lfg` | 一键全流程 |

---

## 解释说明

### 什么是 Compound Mind？

一个让 AI Agent 积累经验、自我迭代的框架：

- **长期记忆** (MEMORY.md)：跨会话保留的知识
- **自动提取**：飞轮任务从日志中提取洞察
- **方案库**：`docs/solutions/` 中结构化、可复用的方案
- **决策追踪**：每个重要决策都被记录和追溯

---

### 核心理念

**克制优于过度，清晰优于复杂。**

| 原则 | 含义 |
|------|------|
| 不要重新造轮子 | 使用已有方案 |
| 不要添加没有意义的工作 | 每行代码都要有价值 |
| 先确定对了再去做 | 不确定就先问 |

---

### 飞轮如何工作

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

每个周期通过复利效应增加价值。

---

## 来源

- [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)
- [ClawIntelligentMemory](https://github.com/denda188/ClawIntelligentMemory)

---

## 许可证

MIT

---

🐢 让飞轮转起来！