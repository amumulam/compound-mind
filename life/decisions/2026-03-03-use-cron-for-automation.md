# 决策：用 OpenClaw Cron 实现定时任务

**日期**：2026-03-03

## 决策内容

使用 OpenClaw 的 Cron 功能实现框架的定时任务，而不是写 shell 脚本。

## 背景

Compound Mind 框架需要多个定时任务来驱动飞轮：
- 检查点提取
- Compound 提取
- 知识验证
- 夜间优化

## 选项

1. 写 shell 脚本 + 系统 cron
2. 使用 OpenClaw 的 Cron 功能

## 决策理由

- OpenClaw Cron 是原生功能，与 Agent 深度集成
- 可以指定 Agent 和 Model
- 支持隔离会话（isolated）
- 自动管理任务状态和日志

## 结果

成功使用 `openclaw cron add` 创建了 4 个定时任务，飞轮正常运行。