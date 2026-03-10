# Compound Mind 框架安装指南

**版本**: v1.6.0  
**最后更新**: 2026-03-10

---

## 前置要求

- OpenClaw 已安装并配置
- Python 3.8+
- Bash shell
- 工作空间：`/root/.openclaw/workspace-baba/`

---

## 快速安装

### 方式一：自动安装（推荐）

```bash
cd /root/.openclaw/workspace-baba
./install.sh
```

**安装流程**：
1. 检查配置文件
2. 验证配置质量
3. 创建 Cron 任务
4. 验证任务创建

**预计时间**: 2-3 分钟

---

### 方式二：手动安装

```bash
# 1. 验证配置
python3 scripts/validate_config.py compound-mind.config.json

# 2. 创建任务
python3 scripts/create_cron_tasks.py compound-mind.config.json

# 3. 验证任务
python3 scripts/verify_tasks.py compound-mind.config.json
```

---

## 验证安装

### 检查任务状态

```bash
openclaw cron list | grep compound-mind
```

**期望输出**：
```
✅ compound-mind-checkpoint    every 6h         ok
✅ compound-mind-compound      0 4 * * *        ok
✅ compound-mind-knowledge     30 2 * * 0       ok
✅ compound-mind-optimizer     0 3 * * 0        ok
✅ compound-mind-plan-check    0 21 * * *       ok
✅ compound-mind-monitor       0 22 * * *       ok
```

### 等待首次执行

- **Monitor 任务**: 22:00 运行（首次生成观测报告）
- **Plan Check 任务**: 21:00 运行（检查计划文件）
- **Checkpoint 任务**: 每 6 小时运行（提取检查点）

### 检查输出文件

```bash
# 观测报告
cat life/observation-reports/YYYY-MM-DD.md

# 健康状态
cat life/health-state.json

# 解决方案
ls -la docs/solutions/
```

---

## 故障排查

### 问题 1: 任务创建失败

**症状**：
```
❌ 创建任务 compound-mind-checkpoint 失败
```

**解决**：
```bash
# 检查 OpenClaw 是否正常运行
openclaw status

# 检查 Gateway 状态
openclaw gateway status

# 重新启动 Gateway
openclaw gateway restart
```

### 问题 2: 配置验证失败

**症状**：
```
❌ 配置验证失败:
  - 任务 checkpoint 缺少 payload.message
```

**解决**：
```bash
# 检查配置文件
cat compound-mind.config.json | python3 -m json.tool

# 修复配置文件（确保每个任务都有 payload.message）
# 重新验证
python3 scripts/validate_config.py compound-mind.config.json
```

### 问题 3: 任务未执行

**症状**：
```
任务状态 ok，但没有生成输出文件
```

**解决**：
```bash
# 手动触发任务
openclaw cron run <task-id>

# 查看任务日志
openclaw cron logs <task-id>

# 检查 Agent 是否正常
openclaw sessions list --active 60
```

### 问题 4: 脚本无权限

**症状**：
```
bash: ./install.sh: Permission denied
```

**解决**：
```bash
chmod +x *.sh scripts/*.py
./install.sh
```

---

## 卸载

```bash
# 1. 删除 Cron 任务
openclaw cron list | grep compound-mind | awk '{print $1}' | xargs -I {} openclaw cron rm {}

# 2. 删除脚本文件
rm -rf scripts/ *.sh

# 3. 删除输出文件（可选）
rm -rf life/observation-reports/ life/health-state.json docs/solutions/
```

**注意**：卸载不会删除以下文件：
- `compound-mind.config.json`（配置文件）
- `CHANGELOG.md`（变更日志）
- `memory/`（每日日志）
- `MEMORY.md`（长期记忆）

---

## 升级

```bash
# 1. 拉取最新代码
git pull origin main

# 2. 运行更新脚本
./update.sh
```

**升级流程**：
1. 备份当前配置
2. 验证新配置
3. 增量更新 Cron 任务
4. 验证更新结果

**回滚**（如有问题）：
```bash
./rollback.sh <备份目录>
```

---

## 下一步

安装完成后：

1. **等待首次任务执行**（Monitor 任务 22:00 运行）
2. **查看观测报告**（`life/observation-reports/YYYY-MM-DD.md`）
3. **配置个性化设置**（可选，修改 `compound-mind.config.json`）
4. **加入社区**（Discord / GitHub Discussions）

---

## 获取帮助

- **文档**: [README.md](README.md)
- **变更日志**: [CHANGELOG.md](CHANGELOG.md)
- **问题反馈**: GitHub Issues
- **社区讨论**: GitHub Discussions

---

*安装愉快！🎉*
