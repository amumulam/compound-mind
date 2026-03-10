# Compound Mind 框架变更日志

本文件记录 Compound Mind 框架的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

---

## [1.6.0] - 2026-03-10

### 新增
- 完整 payload 定义（config.json 包含所有 6 个任务的完整指令）
- validation 规则（每个任务都有 requiredCommands / expectedOutputs / forbiddenPatterns）
- description 字段（说明每个任务的职责）
- metadata 字段（记录版本信息和仓库地址）
- 配置验证脚本（validate_config.py）
- 任务创建脚本（create_cron_tasks.py）
- 任务验证脚本（verify_tasks.py）
- 任务迁移脚本（migrate_cron_tasks.py）
- 安装脚本（install.sh）
- 更新脚本（update.sh）
- 回滚脚本（rollback.sh）
- README.md 框架说明文档
- INSTALL.md 安装指南
- 决策记录（life/decisions/2026-03-10-framework-refactor.md）

### 修复
- Monitor 任务 payload 模糊问题（误报"Flywheel 任务缺失"）
- 所有任务 payload 明确指定输入/输出/命令/判断标准
- monitor 任务 payload 缺少输入/输出定义

### 变更
- config.json 结构扩展（payload + validation + description + metadata）
- 任务创建流程改为自动化脚本
- 版本：1.5.0 → 1.6.0

### 架构升级
- 从"文档 + 手动配置"升级为"配置 + 自动化部署"
- 新增配置验证机制（强制执行最佳实践）
- 新增版本管理系统（CHANGELOG + Git Tag）
- 新增回滚机制（备份 + 恢复）

---

## [未发布]

**新增**:
- README.md - 框架说明文档（简介/功能/配置/故障排查）
- INSTALL.md - 安装指南（快速安装/验证/故障排查/卸载）
- life/decisions/2026-03-10-framework-refactor.md - 决策记录

**状态**: ✅ Phase 4 完成

---

### v1.6.0-alpha3 (2026-03-10)

**新增**:
- migrate_cron_tasks.py - 迁移脚本（更新现有任务以匹配 config.json）

**执行**:
- 迁移所有 6 个现有任务到最新配置
- 验证所有任务与 config.json 一致

**状态**: ✅ Phase 3 完成

---

### v1.6.0-alpha2 (2026-03-10)

**新增**:
- validate_config.py - 配置验证脚本（检查 payload 完整性、validation 规则）
- create_cron_tasks.py - 任务创建脚本（从 config.json 自动创建 Cron 任务）
- verify_tasks.py - 任务验证脚本（验证实际任务与配置一致）
- install.sh - 安装脚本（验证 + 创建 + 验证三步流程）
- update.sh - 更新脚本（备份 + 增量更新 + 验证）
- rollback.sh - 回滚脚本（从备份恢复配置）

**状态**: ✅ Phase 2 完成

---

### v1.6.0-alpha1 (2026-03-10)

**新增**:
- 完整 payload 定义（config.json 包含所有 6 个任务的完整指令）
- validation 规则（每个任务都有 requiredCommands / expectedOutputs / forbiddenPatterns）
- description 字段（说明每个任务的职责）
- metadata 字段（记录版本信息和仓库地址）

**修复**:
- Monitor 任务 payload 模糊问题（误报"Flywheel 任务缺失"）
- 所有任务 payload 明确指定输入/输出/命令

**变更**:
- config.json 结构扩展（payload + validation + description + metadata）
- 版本：1.5.0 → 1.6.0-alpha1

**状态**: ✅ Phase 1 完成

---

## [1.5.0] - 2026-03-09

### 新增
- Monitor 任务（compound-mind-monitor，每天 22:00 运行）
- 观测日报生成（life/observation-reports/YYYY-MM-DD.md）
- 健康状态监测（life/health-state.json）

### 已知问题
- Monitor 任务 payload 定义模糊（2026-03-10 修复）
- 缺乏配置验证机制
- 缺乏版本管理

---

## [1.4.0] - 2026-03-07

### 新增
- 目录规范强制执行机制
- 标记机制保护用户自定义内容（AGENTS.md / HEARTBEAT.md）
- Plan Check 任务（compound-mind-plan-check，每天 21:00）

### 修复
- 文件放错位置问题（plans/ → docs/plans/）
- 违反目录规范问题

### 变更
- AGENTS.md 添加目录规范表格
- HEARTBEAT.md 添加目录结构检测规则

---

## [1.3.0] - 2026-03-06

### 新增
- 主动监测机制（框架健康检查）
- 部分更新机制（用标记保护用户内容）

### 变更
- 配置文件简化（VERSION.json → compound-mind.config.json）
- 增加 cronModel 字段

---

## [1.2.0] - 2026-03-06

### 新增
- 部分更新机制实现
- 标记机制保护用户自定义内容

---

## [1.1.0] - 2026-03-06

### 新增
- 主动监测机制
- 框架健康检查（Cron 任务状态、MEMORY.md 更新、目录结构）

### 变更
- 更新 README 使用 Diátaxis 框架

---

## [1.0.0] - 2026-03-05

### 新增
- Compound Mind 框架正式发布
- 4 个飞轮任务：
  - Checkpoint Extraction（每 6 小时）
  - Compound Extraction（每天 04:00）
  - Knowledge Validation（每周日 02:30）
  - Nighttime Optimizer（每周日 03:00）
- 发布到 GitHub

### 文档
- README 重构（Tutorials/How-to/Reference/Explanation）
- 双语版本（中文 + 英文）

---

## [0.3.0] - 2026-03-04

### 新增
- Compound 环节实现
- 解决方案模板（life/archives/solutions/TEMPLATE.md）
- 索引文件（life/archives/solutions/INDEX.md）
- Compound 提取 Cron 任务（每天 04:00）

### 修复
- 检查点提取首次成功运行

---

## [0.2.0] - 2026-03-03

### 新增
- 复利飞轮启动
- 4 个 cron 定时任务：
  - 检查点提取（每 6 小时）
  - 模式提取（每周日 02:00）
  - 知识验证（每周日 02:30）
  - 夜间优化（每周日 03:00）

### 变更
- Workspace 重构（参考 Compound Engineering Plugin 和 ClawIntelligentMemory）

---

## [0.1.0] - 2026-03-01

### 新增
- Compound Mind 框架概念设计
- 检查点提取机制

---

## 版本说明

| 版本 | 日期 | 里程碑 |
|------|------|--------|
| 0.x.x | 2026-03-01 ~ 2026-03-04 | 原型阶段 |
| 1.0.0 | 2026-03-05 | 正式发布 |
| 1.x.x | 2026-03-06 ~ 至今 | 快速迭代 |
| 1.6.0 | 计划中 | 架构升级（完整配置 + 自动化部署） |

---

## 决策记录索引

- [[2026-03-03-use-cron-for-automation]] - 使用 OpenClaw Cron 实现定时任务
- [[2026-03-08-cron-payload-clarity]] - Cron 任务指令明确性原则
- [[2026-03-10-monitor-fix]] - Monitor 误报修复
- [[2026-03-10-framework-refactor]] - 框架源码根本修复（计划中）

---

*最后更新：2026-03-10*
