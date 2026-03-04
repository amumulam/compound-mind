# 巴巴架构问题完整汇总表（含评估）

> 审查日期：2026-03-04
> 审查人：主人 + 爪爪

---

## 完整问题列表（20 个）

| # | 问题 | 描述 | 严重程度 | 是否误判 | 是否必要解 | 如何解 |
|---|------|------|----------|----------|------------|--------|
| 1 | 设计和实际有差距 | 文档写得好，但执行不到位 | 中 | 否 | 是 | 让飞轮运转，逐步补齐实现 |
| 2 | 职责重叠 | para-system 和 projects 都放设计文档 | 低 | 否 | 是 | 合并为一个目录 |
| 3 | 过时文件没清理 | BOOTSTRAP.md、TODO.md、benchmark 文件 | 中 | 否 | 是 | 删除过时文件 |
| 4 | 缺少版本控制 | 没有 .gitignore | 高 | 否 | 是 | 创建 .gitignore |
| 5 | node_modules 没有 gitignore | compound-memory-framework/node_modules/ 存在，但没有 .gitignore | 中 | 否 | 是 | 添加到 .gitignore |
| 6 | 知识库放错位置 | memory/software-engineering-knowledge.md 不应该和每日日志放一起 | 低 | 否 | 待定 | 移到独立目录或保留（待讨论） |
| 7 | 模板放错位置 | TEMPLATE.md 和 INDEX.md 放在 solutions/，应该放设计目录 | 中 | 否 | 是 | 移动到 compound-mind/ |
| 8 | 没有版本控制 | workspace-baba 没有 Git 初始化 | 高 | 部分 | 否 | workspace 是 agent 运行时，不需要 Git |
| 9 | memory/ 目录混乱 | 每日日志 + 知识库文件混在一起 | 低 | 否 | 待定 | 需要定义知识库位置 |
| 10 | 功能分散 | 模块设计在 projects/，执行在 Cron | 中 | 否 | 否 | 这是设计选择，框架通过 Cron 执行 |
| 11 | 名称混淆 | solutions/ 和 compound-mind/ 名称相似 | 低 | 部分 | 否 | 语义上不混淆（输出 vs 设计） |
| 12 | 只有 README | pattern-extraction 等模块没有实际代码 | 低 | 否 | 否 | 先让飞轮转起来再迭代 |
| 13 | 设计和实际有差距 | 文档写得好，但执行不到位 | 中 | 否 | 是 | 同问题 1 |
| 14 | 过时文件没清理 | BOOTSTRAP.md、TODO.md、benchmark 文件 | 中 | 否 | 是 | 同问题 3 |
| 15 | 职责重叠 | para-system 和 projects 都放设计文档 | 低 | 否 | 是 | 同问题 2 |
| 16 | 遗留实验目录 | compound-memory-framework/ 定位不明 | 中 | 否 | 是 | 删除或明确用途 |
| 17 | 测试文件位置错误 | life/archives/ 下有 benchmark 测试文件 | 低 | 否 | 是 | 删除测试文件 |
| 18 | 根目录文档重复 | ARCHITECTURE.md、FRAMEWORK.md、RELEASE.md 可能重复 | 低 | 待定 | 待定 | 需要检查内容 |
| 19 | node_modules 未排除 | compound-memory-framework/node_modules/ | 中 | 否 | 是 | 同问题 5 |
| 20 | 整体评分 | 7/10——框架设计不错，但"建架子"的痕迹还在 | - | - | - | 持续改进 |

---

## 评估总结

### 必须解决（高优先级）
| 问题 | 解法 |
|------|------|
| #4 缺少版本控制 | ✅ 已创建 .gitignore |
| #3/#14 过时文件没清理 | ✅ 已删除 BOOTSTRAP.md、benchmark 文件 |
| #2/#15 职责重叠 | 合并 para-system 和 projects |
| #7 模板放错位置 | 移动到 compound-mind/ |
| #16 遗留实验目录 | 删除或明确用途 |
| #5/#19 node_modules 未排除 | ✅ 已添加到 .gitignore |

### 待讨论
| 问题 | 需要讨论 |
|------|----------|
| #6 知识库放错位置 | 知识库应该放哪里？ |
| #9 memory/ 目录混乱 | 如何组织？ |
| #18 根目录文档重复 | 需要检查内容 |

### 不需要解决（设计选择或低优先级）
| 问题 | 理由 |
|------|------|
| #8 没有 Git 初始化 | workspace 是运行时，不需要 Git |
| #10 功能分散 | 框架通过 Cron 执行，这是设计选择 |
| #11 名称混淆 | 语义上不混淆（输出 vs 设计） |
| #12 只有 README | 先让飞轮转起来再迭代 |

---

## 已解决

- ✅ #4 创建 .gitignore
- ✅ #3 删除 BOOTSTRAP.md
- ✅ #17 删除 benchmark 测试文件
- ✅ #5/#19 node_modules 添加到 .gitignore

## 待解决

- #2/#15 合并 para-system 和 projects
- #7 移动模板到设计目录
- #16 处理遗留实验目录

## 待讨论

- #6 知识库位置
- #9 memory/ 目录组织
- #18 根目录文档检查