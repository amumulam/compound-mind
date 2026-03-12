![Compound Mind Banner](./docs/assets/banner.jpg)

# Compound Mind

> 让 AI Agent 在每次任务中成长。

🌐 [English Documentation](README.md)

![Version](https://img.shields.io/badge/version-v1.6.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![OpenClaw](https://img.shields.io/badge/OpenClaw-Compatible-orange)
![Last Updated](https://img.shields.io/github/last-commit/amumulam/compound-mind)

---

## 📖 简介

**Compound Mind** 是一个面向 OpenClaw Agent 的自动化经验沉淀系统。它通过定时任务将日常日志转化为可复用的解决方案，实现知识的复利增长。

### 核心理念

> 每天进步 1%，一年增长 37 倍。

Compound Mind 实现了 AI Agent 知识的**复利增长**：
- 📝 **每日日志** 记录原始经验
- 💡 **自动提取** 沉淀可复用方案
- 📚 **结构化存储** 构建知识库
- 🔄 **持续迭代** 实现自我进化

---

## ✨ 功能特性

### 飞轮任务

| 任务 | 频率 | 说明 |
|------|------|------|
| 🔄 **Checkpoint** | 每 6 小时 | 从日志提取关键信息到 MEMORY.md |
| 💡 **Compound** | 每天 04:00 | 从日志自动提取可复用解决方案 |
| 🔍 **知识验证** | 每周日 02:30 | 检查知识孤岛和重复内容 |
| 🛠️ **Optimizer** | 每周日 03:00 | 系统健康维护（Git 提交、清理） |
| 📋 **计划检查** | 每天 21:00 | 确保长期任务有计划文件 |
| 📊 **Monitor** | 每天 22:00 | 框架健康监测并生成报告 |

### 自动化能力

- ✅ **自动记录** - 每日日志自动追加到 MEMORY.md
- ✅ **自动沉淀** - 解决方案自动提取到 `docs/solutions/`
- ✅ **自动验证** - 每周检查知识质量
- ✅ **自动监测** - 每天生成健康报告

---

## 🚀 快速开始

### 前置条件

- 已安装并配置 OpenClaw
- 可使用 OpenClaw Cron 功能

### 安装

```bash
# 克隆仓库
cd /root/.openclaw/workspace-baba
git clone https://github.com/amumulam/compound-mind.git

# 运行安装脚本
cd compound-mind
chmod +x install.sh && ./install.sh
```

### 验证

```bash
# 查看任务状态
openclaw cron list | grep compound-mind

# 查看观测报告
cat life/observation-reports/$(date +%Y-%m-%d).md

# 查看健康状态
cat life/health-state.json
```

---

## 🏗️ 架构设计

```
┌─────────────────────────────────────────────────────────┐
│                    Compound Mind 飞轮                   │
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

### 数据流

```
每日日志 → Checkpoint → MEMORY.md
                ↓
        Compound 提取
                ↓
        docs/solutions/
                ↓
        知识验证
                ↓
        健康报告
```

---

## 📂 目录结构

```
compound-mind/
├── README.md                      # 英文文档
├── README_ZH.md                   # 中文文档
├── compound-mind.config.json      # 框架配置
├── CHANGELOG.md                   # 变更日志
├── install.sh                     # 安装脚本
├── update.sh                      # 更新脚本
├── rollback.sh                    # 回滚脚本
├── scripts/
│   ├── validate_config.py         # 配置验证
│   ├── create_cron_tasks.py       # 任务创建
│   ├── verify_tasks.py            # 任务验证
│   └── migrate_cron_tasks.py      # 任务迁移
├── docs/
│   ├── assets/                    # 图片和 Banner
│   ├── plans/                     # 计划文件
│   ├── solutions/                 # 解决方案
│   └── brainstorms/               # 头脑风暴
├── life/
│   ├── decisions/                 # 决策记录
│   ├── health-state.json          # 健康状态
│   ├── motivation/                # 成就记录
│   └── observation-reports/       # 观测报告
└── memory/                        # 每日日志
```

---

## 📊 运行示例

### 观测报告示例

```markdown
## Compound Mind Monitor 报告
日期：2026-03-12

### 任务状态
| 任务 | 状态 | 最后运行 |
|------|------|----------|
| Checkpoint | ✅ 正常 | 2 小时前 |
| Compound | ✅ 正常 | 8 小时前 |
| Knowledge | ✅ 正常 | 5 天前 |
| Optimizer | ✅ 正常 | 5 天前 |
| Monitor | ✅ 正常 | 刚刚 |

### 健康评分：100%
所有系统正常运行。
```

---

## 🤝 贡献指南

欢迎贡献！您可以通过以下方式帮助：

1. **报告问题** - 发现 Bug？提交 Issue
2. **提交 PR** - 有修复？发送 Pull Request
3. **分享方案** - 将您的方案添加到 `docs/solutions/`
4. **改进文档** - 帮助翻译或改进文档

### 开发环境设置

```bash
# Fork 并克隆
git clone https://github.com/amumulam/compound-mind.git
cd compound-mind

# 安装依赖
npm install

# 运行测试
./test-framework.sh
```

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件。

---

## 🌟 致谢

- 基于 [OpenClaw](https://openclaw.ai) 构建
- 灵感来自复利增长原理
- OpenClaw 社区贡献者的支持

---

![Made with ❤️ for OpenClaw Community](https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-red)
