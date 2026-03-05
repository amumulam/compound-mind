# Compound Extractor 设计文档

## 概述

Compound Extractor 负责从每日日志中提取可复用的解决方案，形成结构化知识库。

## 输入输出

**输入**：`memory/YYYY-MM-DD.md`（过去 N 天的日志）

**输出**：`life/archives/solutions/YYYY-MM-DD-{slug}.md`

## 检测模式

### 1. 问题解决模式

**触发关键词**：
- 解决、修复、搞定、终于、成功、找到原因
- 原来是、关键在于、问题在于

**结构特征**：
- 尝试 → 失败 → 再尝试 → 成功
- 困惑 → 探索 → 发现

**提取内容**：
- 问题背景
- 尝试过程
- 最终方案
- 关键洞察

### 2. 踩坑避坑模式

**触发关键词**：
- 踩坑、注意、不要、坑爹、血泪、教训
- 千万、务必、切记

**提取内容**：
- 坑点描述
- 错误后果
- 正确做法

### 3. 学习发现模式

**触发关键词**：
- 发现、意识到、学到、理解、明白
- 原来如此、恍然大悟

**提取内容**：
- 发现内容
- 为什么重要
- 如何应用

## 执行流程

```
1. 读取 memory/YYYY-MM-DD.md（今天 + 昨天）

2. 按段落分割，匹配检测模式

3. 对匹配的段落：
   a. 提取问题背景
   b. 提取尝试过程
   c. 提取最终方案
   d. 提取关键洞察

4. 生成解决方案文件：
   - 使用 TEMPLATE.md 格式
   - 文件名：YYYY-MM-DD-{slug}.md
   - slug：问题关键词的简短英文

5. 更新 INDEX.md：
   - 在分类下添加链接
   - 添加相关标签

6. 更新 MEMORY.md（可选）：
   - 在"学到的经验"添加引用
```

## Cron 配置

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
    "message": "运行 Compound 提取：\n\n1. 读取 memory/ 目录下最近 2 天的日志\n2. 检测问题解决模式（关键词：解决、修复、搞定、原来是）\n3. 提取可复用的解决方案\n4. 使用 life/archives/solutions/TEMPLATE.md 格式生成文件\n5. 更新 life/archives/solutions/INDEX.md 索引\n\n输出目录：life/archives/solutions/\n\n如果没有可提取的内容，回复 COMPOUND_OK。"
  }
}
```

## 文件结构

```
life/archives/solutions/
├── INDEX.md                    # 索引（人工 + 自动维护）
├── TEMPLATE.md                 # 模板
├── 2026-03-03-bun-proxy-timeout.md  # 示例
├── 2026-03-03-*.md
└── ...
```

## 与其他模块的协作

| 触发器 | 模块 | 输出 |
|--------|------|------|
| 每 6 小时 | 检查点提取 | MEMORY.md 更新 |
| 每天 04:00 | **Compound 提取** | solutions/*.md |
| 每周日 02:00 | 模式提取 | 周报 |
| 每周日 02:30 | 知识验证 | 冲突报告 |
| 每周日 03:00 | 夜间优化 | 系统维护 |

## 避免重复

在生成新的解决方案文件前，检查：
1. `INDEX.md` 是否已有类似问题
2. 相同关键词是否已有解决方案
3. 如果存在，考虑合并或更新而非新建

## 实现状态

- [x] 创建 TEMPLATE.md
- [x] 创建 INDEX.md
- [x] 迁移现有经验（bun 代理问题）
- [ ] 配置 Cron 定时任务
- [ ] 更新 HEARTBEAT.md 添加触发逻辑