# Compound Mind 框架介绍

> 复利心智：让经验自动沉淀、持续增值

---

## 一、痛点

AI Agent 每天处理大量任务，但**经验无法积累**：

| 问题 | 表现 |
|------|------|
| **记忆碎片化** | 信息散落在各次对话，无法复用 |
| **重复踩坑** | 同样的问题解决多次，没有沉淀 |
| **决策不可追溯** | 做过的决定找不到依据 |
| **知识自然衰减** | 长期不用的知识变得模糊或过时 |
| **被动记录** | 需要手动整理，没人做就没积累 |

**核心问题**：Agent 有"短期记忆"，但没有"长期成长"机制。

---

## 二、来源

参考了两个开源项目的设计理念：

### 1. Compound Engineering Plugin

核心概念：**Plan → Work → Review → Compound**

- 前三步是执行
- **Compound 是沉淀**：把解决问题过程中的洞察结构化保存

### 2. ClawIntelligentMemory

核心概念：**存储 + 索引 + 搜索**

- MEMORY.md：长期记忆
- memory/YYYY-MM-DD.md：每日日志
- 自动提取关键信息

### 融合思路

```
Compound Engineering Plugin  →  提供产出层（solutions/）
ClawIntelligentMemory        →  提供存储层（MEMORY.md）
Compound Mind                →  结合两者，形成闭环
```

---

## 三、解决方案

### 核心设计

**自动运转的复利飞轮**：

```
┌─────────────────────────────────────────────────────────┐
│                    Compound Mind                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   memory/YYYY-MM-DD.md                                  │
│          │                                              │
│          ▼                                              │
│   ┌──────────────┐    ┌──────────────┐                  │
│   │ 检查点提取    │───▶│ MEMORY.md    │                  │
│   │ （每 6 小时） │    │ 长期记忆      │                  │
│   └──────────────┘    └──────────────┘                  │
│          │                                              │
│          ▼                                              │
│   ┌──────────────┐    ┌──────────────┐                  │
│   │ 检测器       │───▶│ 标记可沉淀   │                  │
│   │ （心跳时）    │    │ 内容         │                  │
│   └──────────────┘    └──────────────┘                  │
│          │                                              │
│          ▼                                              │
│   ┌──────────────┐    ┌──────────────┐                  │
│   │ Compound 提取 │───▶│ solutions/   │                  │
│   │ （每天 04:00）│    │ 结构化方案    │                  │
│   └──────────────┘    └──────────────┘                  │
│          │                                              │
│          ▼                                              │
│   ┌──────────────┐    ┌──────────────┐                  │
│   │ 模式提取      │───▶│ 周报        │                  │
│   │ （每周日）    │    │ 规律分析     │                  │
│   └──────────────┘    └──────────────┘                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 模块职责

| 模块 | 频率 | 输入 | 输出 |
|------|------|------|------|
| 检查点提取 | 每 6h | 今日日志 | MEMORY.md（决策/事件/学习） |
| Compound 检测 | 每次心跳 | 今日日志 | 标记可沉淀内容 |
| Compound 提取 | 每天 04:00 | 标记内容 | solutions/*.md |
| 模式提取 | 每周日 | 7天日志 | 周报 |
| 知识验证 | 每周日 | MEMORY.md | 冲突报告 |
| 夜间优化 | 每周日 | 整个系统 | 维护报告 |

---

## 四、技术实现

### 依赖

- **OpenClaw**：Agent 框架
- **OpenClaw Cron**：定时任务调度
- **memory_search**：语义搜索

### 文件结构

```
workspace/
├── MEMORY.md                    # 长期记忆（核心）
├── memory/
│   └── YYYY-MM-DD.md            # 每日日志
├── HEARTBEAT.md                 # 心跳任务定义
│
├── life/
│   ├── archives/
│   │   ├── solutions/           # 结构化方案
│   │   │   ├── TEMPLATE.md      # 方案模板
│   │   │   ├── INDEX.md         # 索引
│   │   │   └── YYYY-MM-DD-*.md  # 具体方案
│   │   ├── daily/               # 归档日志
│   │   └── weekly/              # 周报
│   │
│   ├── decisions/               # 决策记录
│   │   ├── README.md
│   │   └── YYYY-MM-DD-*.md
│   │
│   ├── motivation/              # 动力系统
│   │   ├── achievements.json    # 成就
│   │   ├── milestones.json      # 里程碑
│   │   └── streaks.json          # 连胜
│   │
│   └── projects/
│       ├── compound-mind/       # Compound Mind 模块
│       ├── pattern-extraction/  # 模式提取
│       ├── knowledge-validation/# 知识验证
│       └── nighttime-optimizer/ # 夜间优化
│
└── para-system/                 # 设计文档
```

### Cron 配置示例

```json
{
  "name": "compound-extraction",
  "schedule": {
    "kind": "cron",
    "expr": "0 4 * * *",
    "tz": "Asia/Shanghai"
  },
  "sessionTarget": "isolated",
  "payload": {
    "kind": "agentTurn",
    "message": "运行 Compound 提取...",
    "model": "bailian-coding-plan/glm-5"
  }
}
```

---

## 五、工作原理

### 调度方式

**三层调度**：

1. **心跳层**（轻量检测）
   - 每次心跳读取 HEARTBEAT.md
   - 执行检查点提取、Compound 检测
   - 只标记，不生成文件

2. **Cron 层**（重量处理）
   - 按时间表自动触发
   - Compound 提取（每天）、模式提取（每周）
   - 生成结构化输出

3. **事件层**（即时响应）
   - 主人说"记录决策"→ 立即创建决策文件
   - 检测到成就关键词 → 更新 achievements.json

### 检测模式

**Compound 提取会检测三种模式**：

| 模式 | 关键词 | 输出 |
|------|--------|------|
| 问题解决 | 解决、修复、搞定、终于、成功 | 方案文档 |
| 踩坑避坑 | 踩坑、注意、不要、坑爹、教训 | 避坑指南 |
| 学习发现 | 发现、意识到、原来是、关键在于 | 洞察记录 |

---

## 六、能够达成的效果

### 短期效果

- ✅ 不再重复解决相同问题
- ✅ 决策有据可查
- ✅ 每天自动整理经验

### 长期效果

- 📈 **经验复利**：解决问题的方案越多，后续效率越高
- 🎯 **知识体系**：形成领域知识图谱
- 🔄 **自我优化**：定期检测过时/冲突知识
- 📊 **成长可视化**：成就、里程碑、连胜记录

### 量化指标

| 指标 | 目标 |
|------|------|
| solutions/ 文档数 | 每周 +2~5 |
| MEMORY.md 行数 | 控制在 500 行内（超过拆分） |
| 决策文件数 | 重要决策 100% 记录 |
| 成就解锁 | 每周 1~2 个 |

---

## 七、Quickstart：Agent 如何接入

### Step 1：创建目录结构

```bash
mkdir -p life/archives/solutions
mkdir -p life/archives/daily
mkdir -p life/archives/weekly
mkdir -p life/decisions
mkdir -p life/motivation
mkdir -p life/projects/compound-mind
mkdir -p memory
mkdir -p para-system
```

### Step 2：创建核心文件

```bash
# 模板
cat > life/archives/solutions/TEMPLATE.md << 'EOF'
# 问题：{{title}}

> 创建于 {{date}} | 来源：{{source}}

## 背景

## 症状

## 排查过程

## 最终方案

## 关键洞察

## 可复用模式
EOF

# 索引
cat > life/archives/solutions/INDEX.md << 'EOF'
# 解决方案索引

## 按分类

### 开发调试

### 配置部署

## 按标签

EOF

# 长期记忆
cat > MEMORY.md << 'EOF'
# MEMORY.md - 长期记忆

## 身份

## 重要事件

## 学到的经验
EOF

# 每日日志
touch memory/$(date +%Y-%m-%d).md
```

### Step 3：配置 HEARTBEAT.md

```markdown
# HEARTBEAT.md

## 心跳任务

### 1. 检查点提取

读取 `memory/YYYY-MM-DD.md`（今天），提取：

**决策类** → 记录到 `life/decisions/`
**学习类** → 记录到 MEMORY.md
**事件类** → 记录到 MEMORY.md
**成就类** → 更新 `life/motivation/achievements.json`

### 2. Compound 检测

检测关键词：解决、修复、踩坑、发现

---

如果以上任务都已完成，回复 HEARTBEAT_OK。
```

### Step 4：配置 Cron 任务

```bash
# 检查点提取（每 6 小时）
openclaw cron add --name "checkpoint-extraction" \
  --schedule "every:6h" \
  --message "运行检查点提取..."

# Compound 提取（每天 04:00）
openclaw cron add --name "compound-extraction" \
  --schedule "cron:0 4 * * *" \
  --message "运行 Compound 提取..."
```

### Step 5：开始使用

1. **日常记录**：在 `memory/YYYY-MM-DD.md` 记录每天发生的事
2. **自动运转**：心跳和 Cron 自动提取关键信息
3. **查阅经验**：在 `life/archives/solutions/` 搜索历史方案

---

## 总结

**Compound Mind** 是一个让 AI Agent 拥有"长期成长"能力的框架：

- 🔄 **自动运转**：不需要手动维护
- 📈 **复利积累**：经验越用越有价值
- 🎯 **结构化**：方案、决策、成就各有归处
- 🔍 **可检索**：索引 + 语义搜索

**核心理念**：今天的经验，明天的资产。