# last30days API Base URL Override - 开发计划

**项目名称**：last30days API Base URL Override 补丁方案
**策划人**：爪爪
**执行人**：巴巴
**创建日期**：2026-03-07
**预计完成**：待定

---

## 一、需求确认

### 1.1 核心需求

让 last30days 支持自定义 API 地址（Base URL Override）

### 1.2 需要修改的 API

| API | 文件 | 硬编码 URL | 环境变量 |
|-----|------|------------|----------|
| OpenAI | `scripts/lib/openai_reddit.py` | `https://api.openai.com/v1/responses` | `OPENAI_BASE_URL` |
| xAI | `scripts/lib/xai_x.py` | `https://api.x.ai/v1/responses` | `XAI_BASE_URL` |
| Brave | `scripts/lib/brave_search.py` | `https://api.search.brave.com/res/v1/web/search` | `BRAVE_BASE_URL` |
| Parallel | `scripts/lib/parallel_search.py` | `https://api.parallel.ai/v1beta/search` | `PARALLEL_BASE_URL` |
| OpenRouter | `scripts/lib/openrouter_search.py` | `https://openrouter.ai/api/v1/chat/completions` | `OPENROUTER_BASE_URL` |
| ScrapeCreators | `scripts/lib/tiktok.py`, `scripts/lib/instagram.py` | 待确认 | `SCRAPECREATORS_BASE_URL` |

### 1.3 需要确认的问题

| 问题 | 状态 | 说明 |
|------|------|------|
| ScrapeCreators API Base URL 位置 | ⏳ 待确认 | 需要查看 tiktok.py 和 instagram.py |
| 每个 API client 的具体修改位置 | ⏳ 待确认 | 需要深入分析代码结构 |

---

## 二、技术方案

### 2.1 方案选择

**Git Hook + Patch 方案**（爪爪推荐）

**优点**：
- 不污染源仓库
- 自动化应用
- 持续跟进上游更新

**缺点**：
- 需要维护补丁文件
- 上游大改动可能冲突

### 2.2 工作流程

```
git pull
    ↓
拉取新代码
    ↓
Post-merge Hook 触发
    ↓
自动应用补丁
    ↓
结果：新功能 + 自定义 Base URL
```

---

## 三、实现步骤

### Step 1: 深入分析源码（待执行）

**目标**：确认每个 API client 的具体修改位置

**任务**：
- [ ] 分析 openai_reddit.py 的 URL 使用位置
- [ ] 分析 xai_x.py 的 URL 使用位置
- [ ] 分析 brave_search.py 的 URL 使用位置
- [ ] 分析 parallel_search.py 的 URL 使用位置
- [ ] 分析 openrouter_search.py 的 URL 使用位置
- [ ] 分析 tiktok.py 和 instagram.py 的 ScrapeCreators URL 位置

---

### Step 2: 编写补丁（待执行）

**目标**：为每个 API 创建独立的补丁文件

**任务**：
- [ ] 创建 `patches/` 目录
- [ ] 编写 `001-openai-base-url.patch`
- [ ] 编写 `002-xai-base-url.patch`
- [ ] 编写 `003-brave-base-url.patch`
- [ ] 编写 `004-parallel-base-url.patch`
- [ ] 编写 `005-openrouter-base-url.patch`
- [ ] 编写 `006-scrapecreators-base-url.patch`（如果需要）
- [ ] 创建 `apply-all.sh` 脚本

---

### Step 3: 创建 Git Hook（待执行）

**目标**：实现 pull 后自动应用补丁

**任务**：
- [ ] 创建 `.git/hooks/post-merge`
- [ ] 设置执行权限
- [ ] 测试 Hook 是否正常工作

---

### Step 4: 测试验证（待执行）

**目标**：确保补丁正确应用且功能正常

**任务**：
- [ ] 测试补丁应用：`bash patches/apply-all.sh`
- [ ] 测试诊断：`python3 scripts/last30days.py --diagnose`
- [ ] 测试实际搜索功能
- [ ] 测试 `git pull` 后自动应用

---

### Step 5: 文档编写（待执行）

**目标**：编写使用文档

**任务**：
- [ ] 编写环境变量配置说明
- [ ] 编写补丁维护指南
- [ ] 编写故障排除指南

---

## 四、风险评估

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|----------|
| 上游修改了相同代码行 | 中 | 中 | 补丁失败时输出警告，手动更新 |
| 补丁不兼容新版本 | 低 | 中 | 测试后更新补丁 |
| Git Hook 权限问题 | 低 | 低 | 确保 hook 有执行权限 |
| 环境变量命名冲突 | 低 | 低 | 使用 `XXX_BASE_URL` 格式 |

---

## 五、测试计划

### 5.1 单元测试

- 测试每个补丁能否正确应用
- 测试环境变量是否正确读取

### 5.2 集成测试

- 测试 `git pull` 后自动应用
- 测试实际搜索功能

### 5.3 回归测试

- 测试上游更新后补丁是否仍然适用

---

## 六、后续维护

### 6.1 定期检查

```bash
# 检查补丁是否仍然适用
git apply --check patches/*.patch

# 查看上游更新
git log HEAD..origin/main --oneline
```

### 6.2 更新补丁

如果补丁失败：
1. 查看失败原因
2. 更新补丁文件
3. 重新应用

---

## 七、交付物

| 交付物 | 状态 |
|--------|------|
| 补丁文件（6 个） | ⏳ 待开发 |
| Git Hook 脚本 | ⏳ 待开发 |
| apply-all.sh 脚本 | ⏳ 待开发 |
| 使用文档 | ⏳ 待编写 |

---

## 八、时间安排

| 阶段 | 预计时间 |
|------|----------|
| Step 1: 深入分析源码 | 待定 |
| Step 2: 编写补丁 | 待定 |
| Step 3: 创建 Git Hook | 待定 |
| Step 4: 测试验证 | 待定 |
| Step 5: 文档编写 | 待定 |

---

**下一步行动**：确认需要确认的问题，然后开始 Step 1。