# 检查点机制设计

## 核心逻辑

每次心跳时检查：
1. 读取今天的日志 `memory/YYYY-MM-DD.md`
2. 提取关键信息（决策、学习、重要事件）
3. 更新 `MEMORY.md` 的相关部分

## 触发方式

OpenClaw 的心跳机制 - 在 `HEARTBEAT.md` 中添加任务。

## 提取规则

### 决策类
- 包含"决定"、"选择了"、"主人说"等关键词
- 记录到 `life/decisions/` 和 MEMORY.md

### 学习类
- 包含"学会了"、"理解了"、"发现"、"意识到"等
- 记录到 MEMORY.md 的相关知识区域

### 重要事件
- 包含"认识"、"完成"、"解锁"等
- 记录到 MEMORY.md

### 成就类
- 包含"成就"、"里程碑"等
- 更新 `life/motivation/achievements.json`

## 实现

在 HEARTBEAT.md 中添加指令，让 agent 在心跳时执行检查点逻辑。