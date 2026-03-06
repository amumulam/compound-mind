# Compound Mind 主动监测方案设计

## 设计原则

| 原则 | 说明 |
|------|------|
| 复用现有能力 | 不重新造轮子，利用 OpenClaw 心跳和 Cron |
| 最小干预 | 只检测关键异常，不做过度监控 |
| 渐进增强 | 先实现基础监测，后续可扩展 |

---

## 监测架构

```
┌─────────────────────────────────────────────────────────┐
│                    Heartbeat (每 30 分钟)               │
│                                                         │
│  1. 检查 Cron 任务状态                                   │
│  2. 检查 MEMORY.md 更新频率                              │
│  3. 记录健康状态                                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                  health-state.json                      │
│                                                         │
│  {                                                      │
│    "lastCheck": "2026-03-06T13:00:00Z",               │
│    "cronTasks": {                                       │
│      "checkpoint": { "status": "ok", "lastRun": "..." },│
│      "compound": { "status": "ok", "lastRun": "..." },  │
│      "knowledge": { "status": "idle", "lastRun": "..." }│
│    },                                                   │
│    "memoryUpdate": "2026-03-06T12:00:00Z",             │
│    "alerts": []                                         │
│  }                                                      │
└─────────────────────────────────────────────────────────┘
```

---

## 监测项设计

### 1. Cron 任务状态检测

**检测项**：
| 任务 | 正常状态 | 异常条件 |
|------|----------|----------|
| compound-mind-checkpoint | ok / error | status=error 或 超过 12h 未运行 |
| compound-mind-compound | ok / error | status=error 或 超过 48h 未运行 |
| compound-mind-knowledge | idle / ok / error | status=error |
| compound-mind-optimizer | idle / ok / error | status=error |

**实现**：
```bash
# 检查任务状态
openclaw cron list --json | jq '.[] | select(.name | startswith("compound-mind"))'
```

---

### 2. MEMORY.md 更新检测

**检测项**：
- 最后更新时间
- 是否超过 24h 未更新

**实现**：
```bash
# 检查 MEMORY.md 修改时间
stat -c %Y MEMORY.md
```

---

### 3. 目录结构完整性检测

**检测项**：
- 必要目录是否存在
- 必要文件是否存在

**实现**：
```bash
# 检查目录
[ -d "docs/solutions" ] && [ -d "life/decisions" ] && [ -d "memory" ]
```

---

## HEARTBEAT.md 更新

```markdown
# HEARTBEAT.md

## 心跳任务

每次心跳时按顺序检查：

### 1. 框架健康检查

检查 Compound Mind 框架运行状态：

1. **Cron 任务状态**
   - 检查 compound-mind-* 任务是否正常
   - 记录状态到 health-state.json

2. **MEMORY.md 更新检测**
   - 检查最后更新时间
   - 超过 24h 未更新 → 提醒主人

3. **目录结构检测**
   - 检查必要目录/文件是否存在

### 2. 检查点提取

（原有逻辑）

---

如果以上任务都已完成或无需处理，回复 HEARTBEAT_OK。
```

---

## 状态文件设计

**位置**：`life/health-state.json`

```json
{
  "lastCheck": "2026-03-06T13:00:00Z",
  "version": "1.0.0",
  "cronTasks": {
    "checkpoint": {
      "status": "ok",
      "lastRun": "2026-03-06T12:00:00Z",
      "nextRun": "2026-03-06T18:00:00Z"
    },
    "compound": {
      "status": "ok",
      "lastRun": "2026-03-06T04:00:00Z",
      "nextRun": "2026-03-07T04:00:00Z"
    },
    "knowledge": {
      "status": "idle",
      "lastRun": null,
      "nextRun": "2026-03-09T02:30:00Z"
    },
    "optimizer": {
      "status": "idle",
      "lastRun": null,
      "nextRun": "2026-03-09T03:00:00Z"
    }
  },
  "memoryUpdate": "2026-03-06T12:00:00Z",
  "directoryCheck": {
    "docs/solutions": true,
    "life/decisions": true,
    "memory": true,
    "MEMORY.md": true
  },
  "alerts": []
}
```

---

## 异常处理

### 检测到异常时

1. **记录到 health-state.json**
   ```json
   {
     "alerts": [
       {
         "type": "cron_failure",
         "task": "checkpoint",
         "message": "compound-mind-checkpoint failed at 2026-03-06T12:00:00Z",
         "timestamp": "2026-03-06T13:00:00Z"
       }
     ]
   }
   ```

2. **通知主人**
   - 在心跳回复中提及异常
   - 不要在深夜通知（23:00-08:00）

---

## 实现优先级

| 优先级 | 监测项 | 理由 |
|--------|--------|------|
| P0 | Cron 任务状态检测 | 核心功能 |
| P1 | MEMORY.md 更新检测 | 知识积累关键 |
| P2 | 目录结构检测 | 低频异常 |

---

## 扩展性

后续可扩展：
- 检查 solutions 数量增长
- 检查决策文件完整性
- 提供健康报告命令

---

**设计原则总结**：
- 复用心跳机制，不新增 Cron 任务
- 状态文件轻量，易于解析
- 只检测关键异常，避免噪音

EOF