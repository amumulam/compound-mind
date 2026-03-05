# Compound Mind Framework

> 复利心智：让 AI Agent 拥有自我迭代的能力

乌龟签名：🐢

---

## 是什么

Compound Mind 是一个为 OpenClaw Agent 设计的框架，融合了：

- **Compound Engineering Plugin** — 提供工作流能力（/ce:plan, /ce:compound 等）
- **ClawIntelligentMemory** — 提供记忆能力（检查点提取、知识验证）

**核心理念**：克制优于过度，清晰优于复杂。

---

## 核心能力

### 工作流（来自 CE Plugin）

| 命令 | 用途 |
|------|------|
| `/ce:plan` | 创建计划 → docs/plans/ |
| `/ce:brainstorm` | 头脑风暴 → docs/brainstorms/ |
| `/ce:compound` | 沉淀解决方案 → docs/solutions/ |
| `/ce:review` | 多视角审核 |
| `/lfg` | 一键全流程 |

### 记忆系统（自动运转）

| 任务 | 频率 | 作用 |
|------|------|------|
| 检查点提取 | 每 6 小时 | 从日志提取关键信息 → MEMORY.md |
| Compound 提取 | 每天 04:00 | 沉淀可复用的解决方案 → docs/solutions/ |
| 知识验证 | 每周日 02:30 | 检测过时/孤立/重复内容 |
| 夜间优化 | 每周日 03:00 | 系统维护 |

---

## 安装

```bash
git clone https://github.com/amumulam/compound-mind.git
cd compound-mind
./install.sh
```

交互式界面会引导你：
1. 选择 OpenClaw 安装目录
2. 选择要安装的 workspace
3. 选择模型（从 openclaw.json 读取）

---

## 更新

```bash
cd compound-mind
./update.sh
```

更新脚本会：
1. 检查远程仓库最新版本
2. 对比本地版本
3. 更新 Cron 任务 payload
4. 同步目录结构
5. 下载最新 VERSION.json

**保留内容**：
- memory/
- MEMORY.md
- docs/solutions/
- life/decisions/
- life/motivation/

---

## 卸载

```bash
cd compound-mind
./uninstall.sh
```

卸载脚本会：
1. 删除 Cron 任务（compound-mind-*）
2. 删除 docs/
3. 删除 life/
4. 移除 AGENTS.md 中的 Compound Mind 规则

**保留内容**：
- memory/
- MEMORY.md

---

## 版本管理

当前版本：`1.0.0`

版本信息存储在 `compound-mind.config.json`：

```json
{
  "version": "1.0.0",
  "name": "compound-mind",
  "repository": "https://github.com/amumulam/compound-mind"
}
```

---

## 目录结构

```
workspace/
├── AGENTS.md              # 操作手册（框架会追加规则）
├── IDENTITY.md            # 身份 + 工程品味原则
├── SOUL.md                # 价值观
├── USER.md                # 主人信息
├── TOOLS.md               # 具体配置
├── HEARTBEAT.md           # 心跳任务
├── MEMORY.md              # 长期记忆（不自动裁剪）
├── memory/                # 每日日志（永久保留）
├── docs/                  # CE Plugin 输出
│   ├── solutions/         # 实践知识（/ce:compound 输出）
│   ├── plans/             # 计划文档（/ce:plan 输出）
│   └── brainstorms/       # 头脑风暴（/ce:brainstorm 输出）
├── life/                  # Agent 维护
│   ├── decisions/         # 决策记录
│   └── motivation/        # 成就/里程碑/连胜
└── work/                  # 工作目录（可选）
```

---

## 目录职责

| 目录 | 职责 | 性质 |
|------|------|------|
| `docs/` | 工作产出 | 面向任务，可删除重建 |
| `life/` | 生命历程 | 面向成长，长期保留 |
| `memory/` | 每日日志 | 原始记录，永久保留 |

---

## 工程品味原则

**核心理念**：克制优于过度，清晰优于复杂。

### 优先原则

1. **不要重新造轮子** — 依赖已有方案，不自己设计
2. **不要添加没有意义的工作量** — 每一行代码都要有价值
3. **先确定对了再去做** — 不确定就先问

### 具体原则

1. **职责分离** — 一个模块只做一件事
2. **最小干预** — 能不动的就不动
3. **避免过早优化** — 问题没出现时不提前设计解决方案
4. **尊重主体自主权** — MEMORY.md 是 Agent 自己的文件，不自动裁剪
5. **遵循原设计意图** — 不为了"更好"而改变原有边界

---

## Todo 处理规范

**不使用独立的 todos/ 目录。**

| 类型 | 存放位置 |
|------|----------|
| 临时 Todo | memory/YYYY-MM-DD.md |
| 长远/阶段性 Todo | docs/plans/（用 /ce:plan） |

---

## 飞轮度量

| 指标 | 目标 |
|------|------|
| solutions 数量 | 每周 +2 |
| MEMORY.md 覆盖率 | >80% |
| 检查点提取率 | >90% |
| 决策追溯率 | 100% |

---

## 来源

- [Compound Engineering Plugin](https://github.com/EveryInc/compound-engineering-plugin)
- [ClawIntelligentMemory](https://github.com/denda188/ClawIntelligentMemory)
- [爪爪的融合博文](https://amumulam.github.io/zhuazhua-and-friends-blog/blog/compound-engineering-intelligent-memory-fusion)

---

## 许可证

MIT

---

🐢 让飞轮转起来！