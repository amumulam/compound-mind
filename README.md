# Compound Mind 框架

**版本**: v1.6.0-alpha3  
**作者**: 巴巴  
**状态**: 开发中

---

## 简介

Compound Mind 是一个自动化经验沉淀系统，通过定时任务驱动知识复利增长。

**核心理念**：每天进步 1%，一年增长 37 倍。

---

## 功能特性

### 飞轮任务

| 任务 | 频率 | 说明 |
|------|------|------|
| Checkpoint | 每 6 小时 | 从日志提取关键信息到 MEMORY.md |
| Compound | 每天 04:00 | 从日志提取可复用的解决方案 |
| Knowledge | 每周日 02:30 | 检查知识孤岛和重复内容 |
| Optimizer | 每周日 03:00 | 系统健康维护（Git 提交、清理） |
| Plan Check | 每天 21:00 | 检查长期任务是否有对应计划文件 |
| Monitor | 每天 22:00 | 框架监测并生成观测报告 |

### 自动化能力

- ✅ 自动记录：每日日志自动追加到 MEMORY.md
- ✅ 自动沉淀：解决方案自动提取到 docs/solutions/
- ✅ 自动验证：每周检查知识质量
- ✅ 自动监测：每天生成健康报告

---

## 快速开始

### 安装

```bash
cd /root/.openclaw/workspace-baba
./install.sh
```

### 验证

```bash
# 查看任务状态
openclaw cron list | grep compound-mind

# 查看观测报告
cat life/observation-reports/YYYY-MM-DD.md

# 查看健康状态
cat life/health-state.json
```

---

## 目录结构

```
/root/.openclaw/workspace-baba/
├── compound-mind.config.json    # 框架配置（任务定义 + payload）
├── CHANGELOG.md                  # 变更日志
├── install.sh                    # 安装脚本
├── update.sh                     # 更新脚本
├── rollback.sh                   # 回滚脚本
├── scripts/
│   ├── validate_config.py        # 配置验证
│   ├── create_cron_tasks.py      # 任务创建
│   ├── verify_tasks.py           # 任务验证
│   └── migrate_cron_tasks.py     # 任务迁移
├── docs/
│   ├── plans/                    # 计划文件
│   ├── solutions/                # 解决方案
│   └── brainstorms/              # 头脑风暴
├── life/
│   ├── decisions/                # 决策记录
│   ├── health-state.json         # 健康状态
│   ├── motivation/               # 成就记录
│   └── observation-reports/      # 观测报告
└── memory/                       # 每日日志
```

---

## 配置说明

### compound-mind.config.json

```json
{
  "version": "1.6.0",
  "name": "compound-mind",
  "tasks": {
    "checkpoint": {
      "name": "compound-mind-checkpoint",
      "schedule": "every 6h",
      "payload": {
        "message": "...",
        "model": "bailian-coding-plan/glm-4.7",
        "timeoutSeconds": 300
      },
      "validation": {
        "requiredCommands": ["读取 memory/", "写入 MEMORY.md"],
        "expectedOutputs": ["MEMORY.md"],
        "forbiddenPatterns": ["只输出摘要"]
      }
    }
  }
}
```

**字段说明**：
- `version`: 语义化版本号
- `schedule`: 调度（`every 6h` 或 cron 表达式 `0 4 * * *`）
- `payload.message`: Agent 执行指令（必须明确输入/处理/输出/判断标准）
- `validation`: 验证规则（安装/更新时自动验证）

---

## 更新与回滚

### 更新

```bash
./update.sh
```

**流程**：
1. 备份当前配置
2. 验证新配置
3. 增量更新 Cron 任务
4. 验证更新结果

### 回滚

```bash
./rollback.sh <备份目录>
```

**示例**：
```bash
./rollback.sh 2026-03-10-230000
```

---

## 故障排查

### 任务未执行

```bash
# 检查任务状态
openclaw cron list | grep compound-mind

# 查看任务日志
openclaw cron logs <task-id>
```

### 配置验证失败

```bash
# 手动验证配置
python3 scripts/validate_config.py compound-mind.config.json
```

### 观测报告未生成

```bash
# 手动触发 Monitor 任务
openclaw cron run <monitor-task-id>

# 检查输出目录
ls -la life/observation-reports/
```

---

## 最佳实践

### 1. 每日检查

- 查看 `memory/YYYY-MM-DD.md` 是否更新
- 查看 `life/health-state.json` 健康状态

### 2. 每周检查

- 查看 `docs/solutions/` 新增方案
- 查看 `life/observation-reports/` 观测报告

### 3. 每月检查

- 回顾 `MEMORY.md` 长期记忆
- 清理过时的解决方案

---

## 版本历史

详见 [CHANGELOG.md](CHANGELOG.md)

| 版本 | 日期 | 里程碑 |
|------|------|--------|
| v1.6.0 | 2026-03-10 | 完整配置 + 自动化部署 |
| v1.5.0 | 2026-03-09 | 新增 Monitor 任务 |
| v1.4.0 | 2026-03-07 | 目录规范强制执行 |
| v1.0.0 | 2026-03-05 | 正式发布 |

---

## 贡献

**问题反馈**: 创建 Issue  
**功能建议**: 创建 Discussion  
**代码贡献**: 创建 PR

---

## 许可证

MIT License

---

*最后更新：2026-03-10*
