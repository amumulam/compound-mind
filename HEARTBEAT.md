# HEARTBEAT.md

## 心跳任务

每次心跳时按顺序检查：

### 1. 框架健康检查

<!-- COMPOUND_MIND_START -->
检查 Compound Mind 框架运行状态：

**Cron 任务状态检测**：
- 检查 compound-mind-* 任务状态
- 记录到 `life/health-state.json`
- 异常条件：status=error 或超时未运行

**MEMORY.md 更新检测**：
- 检查最后更新时间
- 超过 24h 未更新 → 提醒主人

**目录结构检测**：
- 检查 docs/solutions/, life/decisions/, memory/ 是否存在

**目录规范检测（新增）**：
- 检查是否有错误的目录：`plans/`, `solutions/`, `brainstorms/`
- 如果存在，在心跳回复中警告："发现错误的目录结构，请移动到正确位置"
- 错误位置 → 正确位置映射：
  - `plans/` → `docs/plans/`
  - `solutions/` → `docs/solutions/`
  - `brainstorms/` → `docs/brainstorms/`

**异常通知**：
- 检测到异常时，在心跳回复中提及
- 不在深夜通知（23:00-08:00）
<!-- COMPOUND_MIND_END -->

### 2. 观测日报检测

检查是否需要生成观测日报：

**检测逻辑**：
- 检查 `life/observation-reports/YYYY-MM-DD.md` 是否存在
- 不存在 → 生成观测日报
- 存在 → 跳过

**观测日报内容**：
1. 飞轮运行状态（Cron 任务检查）
2. 框架问题列表
3. 优化建议
4. 对标设计初衷
5. 感悟与思考

**生成时间**：建议每天 22:00-23:00

### 3. 检查点提取

读取 `memory/YYYY-MM-DD.md`（今天），提取：

**决策类** → 记录到 `life/decisions/` 和 MEMORY.md
- 关键词：决定、选择、主人说、确认

**学习类** → 记录到 MEMORY.md 或专门知识文件
- 关键词：学会、理解、发现、意识到、学到

**重要事件** → 记录到 MEMORY.md
- 关键词：认识、完成、解锁、里程碑

**成就类** → 更新 `life/motivation/achievements.json`
- 关键词：成就、首次、成功

### 2. Compound 检测（轻量）

检测今日日志中是否有可沉淀的解决方案（标记即可，Cron 04:00 会提取）：

**问题解决模式**：关键词 `解决、修复、搞定、终于、成功`
**踩坑避坑模式**：关键词 `踩坑、注意、不要、坑爹、教训`

### 3. 坑点检测

检测常见的遗漏和问题：

**未沉淀的解决方案**
- 检查 memory/YYYY-MM-DD.md 是否有"解决/修复/搞定"但未在 solutions/ 中
- 提醒：主人，X 问题已解决，是否需要 /ce:compound 沉淀？

**未记录的决策**
- 检查是否有"决定/选择/确认"但未在 life/decisions/ 中
- 提醒：主人，X 决策未记录，是否需要创建决策文件？

**未处理的 Todo**
- 检查 memory/YYYY-MM-DD.md 中的 `[ ]` 未完成项
- 超过 3 天未处理 → 提醒主人

**检查点质量**
- 检查 MEMORY.md 是否超过 7 天未更新
- 提醒：MEMORY.md 可能过时

### 4. 检查频率

| 任务 | 频率 | 时间 |
|------|------|------|
| 检查点提取 | 每次心跳 | - |
| Compound 检测 | 每次心跳 | - |
| 坑点检测 | 每次心跳 | - |
| Compound 提取 | 每天 | 04:00 |
| 模式提取 | 每周日 | 02:00 |
| 知识验证 | 每周日 | 02:30 |
| 夜间优化 | 每周日 | 03:00 |

---

## 检查状态追踪

心跳时更新 `memory/heartbeat-state.json`：

```json
{
  "lastChecks": {
    "checkpoint": "ISO时间戳",
    "compound": "ISO时间戳",
    "pitfall": "ISO时间戳"
  },
  "alerts": []
}
```

---

如果以上任务都已完成或无需处理，回复 HEARTBEAT_OK。