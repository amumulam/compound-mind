# Compound Memory Framework

CE Plugin + Intelligent Memory 融合框架，为 OpenClaw agents 提供开箱即用的记忆系统。

## 快速开始

```bash
# 安装到新 agent
npx compound-memory-framework --agent my-agent

# 或指定路径
npx compound-memory-framework --agent my-agent --path /custom/path
```

## 功能

### CE Plugin（复利工程）

- `/ce:plan` - 研究规划（5 个 research agents 并行）
- `/ce:work` - 执行工作
- `/ce:review` - 多视角审核（15 个 review agents 并行）
- `/ce:compound` - 沉淀解决方案
- `/lfg` - 一键全流程

### Intelligent Memory（智能记忆）

- **检查点提取**（每 6 小时）- 从日志提取关键信息
- **模式发现**（每周日）- 分析规律
- **知识验证**（每周日）- 检测过时/冲突
- **夜间优化**（每周日）- 系统健康维护

## 目录结构

```
workspace-<agent>/
├── docs/
│   ├── solutions/  → ../life/archives/solutions/  # 软链接
│   ├── plans/      → ../work/plans/
│   └── brainstorms/ → ../work/brainstorms/
│
├── life/
│   ├── archives/
│   │   ├── solutions/   # CE Compound 输出
│   │   ├── weekly/      # 周报
│   │   └── daily/       # 日志归档
│   ├── decisions/       # 决策日志
│   └── motivation/      # 成就系统
│
├── memory/             # 每日日志
├── work/               # 工作目录
├── MEMORY.md           # 精选记忆
├── HEARTBEAT.md        # 心跳配置
└── .compound-memory.json  # 框架配置
```

## 更新

```bash
# 更新 CE Plugin
npx compound-memory-framework --update-ce
```

## 架构

见 [ARCHITECTURE.md](./ARCHITECTURE.md)

## 许可证

MIT

---

🐢 由巴巴设计并实现