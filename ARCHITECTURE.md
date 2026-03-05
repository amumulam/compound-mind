# Compound Memory Framework - 完整架构设计

## 一、设计原则

| 组件 | 策略 | 理由 |
|------|------|------|
| CE Plugin | 追踪上游更新 | 活跃维护，功能丰富 |
| Intelligent Memory | 基于 v2.0，独立维护 | 原项目更新慢，需自主迭代 |

## 二、目录映射问题

### 问题：路径重合

| CE Plugin 路径 | Intelligent Memory 路径 | 功能 |
|----------------|------------------------|------|
| `docs/solutions/` | `life/archives/solutions/` | Compound 输出 |
| `docs/plans/` | `work/plans/` | 计划文档 |
| `docs/brainstorms/` | `work/brainstorms/` | 头脑风暴 |
| - | `memory/` | 每日日志 |
| - | `MEMORY.md` | 精选记忆 |
| - | `life/decisions/` | 决策日志 |
| - | `life/motivation/` | 成就系统 |

### 解决方案：统一路径映射

```
workspace-baba/
│
├── docs/                           # CE Plugin 的工作目录
│   ├── solutions/  → ../life/archives/solutions/   # 软链接
│   ├── plans/      → ../work/plans/                 # 软链接
│   └── brainstorms/ → ../work/brainstorms/          # 软链接
│
├── life/                           # Intelligent Memory 的核心
│   ├── archives/
│   │   ├── solutions/              # CE Compound 输出（真实位置）
│   │   ├── weekly/                 # 周报
│   │   └── daily/                  # 日志归档
│   ├── decisions/                  # 决策日志
│   └── motivation/                 # 成就系统
│
├── memory/                         # 每日日志
│   ├── 2026-03-03.md
│   └── ...
│
├── work/                           # 工作目录
│   ├── plans/                      # CE 计划（真实位置）
│   ├── brainstorms/                # CE 头脑风暴（真实位置）
│   └── todos/
│
├── MEMORY.md                       # 精选记忆
├── para-system/                    # 定时任务配置
│
└── .compound-memory.json           # 融合框架配置
```

### 软链接配置

```bash
# 创建 docs 目录
mkdir -p docs

# 创建软链接
ln -s ../life/archives/solutions docs/solutions
ln -s ../work/plans docs/plans
ln -s ../work/brainstorms docs/brainstorms
```

## 三、适配 CE Plugin 规则

### CE Plugin 的关键规则

1. **compound-docs skill**：
   - 输出到 `docs/solutions/<category>/<problem>.md`
   - 使用 YAML frontmatter
   - 按问题类型分类

2. **工作流命令**：
   - `/ce:plan` → 写入 `docs/plans/`
   - `/ce:brainstorm` → 写入 `docs/brainstorms/`
   - `/ce:compound` → 写入 `docs/solutions/`

### Intelligent Memory 适配

```
检查点提取：
  读取：docs/solutions/ → life/archives/solutions/
  提取关键信息 → 更新 MEMORY.md

模式发现：
  分析：life/archives/solutions/
  输出：life/archives/weekly/YYYY-WW.md

知识验证：
  检查：MEMORY.md + life/archives/solutions/
  报告：life/archives/knowledge-report.md
```

## 四、数据流设计

```
┌─────────────────────────────────────────────────────────────────┐
│                        任务开始                                  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│  /ce:plan                                                       │
│  ├─→ memory_search 检索历史经验                                  │
│  ├─→ 5 个 research agents 并行研究                               │
│  └─→ 输出到 docs/plans/ → work/plans/                           │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│  /ce:work                                                       │
│  └─→ 执行工作，追踪进度                                          │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│  /ce:review                                                     │
│  └─→ 15 个 review agents 并行审核                                │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│  /ce:compound                                                   │
│  └─→ 输出到 docs/solutions/ → life/archives/solutions/          │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│  检查点提取（每 6h，自动）                                        │
│  ├─→ 读取 life/archives/solutions/                              │
│  ├─→ 提取关键信息                                                │
│  ├─→ 更新 MEMORY.md                                             │
│  ├─→ 更新 achievements.json                                     │
│  └─→ 记录决策日志                                                │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│  模式发现（每周日，自动）                                         │
│  └─→ 分析 solutions，输出周报                                    │
└─────────────────────────────────────────────────────────────────┘
```

## 五、一键安装方案

### 安装脚本架构

```
compound-memory-framework/
├── package.json
├── bin/
│   └── compound-memory-init      # CLI 入口
├── lib/
│   ├── index.js                  # 主逻辑
│   ├── installer.js              # 安装器
│   ├── ce-plugin.js              # CE Plugin 安装
│   ├── workspace.js              # Workspace 创建
│   ├── symlinks.js               # 软链接创建
│   └── cron-setup.js             # Cron 配置
├── templates/
│   ├── MEMORY.md.tmpl
│   ├── HEARTBEAT.md.tmpl
│   ├── achievements.json.tmpl
│   └── .compound-memory.json.tmpl
└── README.md
```

### CLI 使用方式

```bash
# 方式 1: npx 一键安装
npx compound-memory-framework --agent my-agent

# 方式 2: 全局安装后使用
npm install -g compound-memory-framework
compound-memory-init --agent my-agent

# 方式 3: 指定 workspace 路径
compound-memory-init --agent my-agent --path /custom/path
```

### 安装流程

```javascript
// lib/index.js
async function install(options) {
  const { agent, path } = options;
  
  console.log("🚀 Installing Compound Memory Framework...");
  
  // Step 1: 检查环境
  await checkEnvironment();
  
  // Step 2: 安装 CE Plugin
  await installCEPlugin();
  
  // Step 3: 创建 Workspace 结构
  await createWorkspace(agent, path);
  
  // Step 4: 创建软链接
  await createSymlinks(agent, path);
  
  // Step 5: 配置 Cron 任务
  await setupCron(agent);
  
  // Step 6: 初始化 Git
  await initGit(agent, path);
  
  console.log("✅ Installation complete!");
  console.log(`   Workspace: ${path || `~/.openclaw/workspace-${agent}`}`);
}
```

### 详细步骤

#### Step 1: 检查环境

```javascript
async function checkEnvironment() {
  // 检查 bun
  if (!commandExists('bun')) {
    console.log("Installing bun...");
    await exec('curl -fsSL https://bun.sh/install | bash');
  }
  
  // 检查 OpenClaw
  if (!fs.existsSync(`${process.env.HOME}/.openclaw`)) {
    throw new Error("OpenClaw not found. Please install OpenClaw first.");
  }
}
```

#### Step 2: 安装 CE Plugin

```javascript
async function installCEPlugin() {
  console.log("📦 Installing CE Plugin...");
  
  await exec('bunx @every-env/compound-plugin install compound-engineering --to openclaw');
  
  console.log("✅ CE Plugin installed");
}
```

#### Step 3: 创建 Workspace

```javascript
async function createWorkspace(agent, customPath) {
  const workspace = customPath || `${process.env.HOME}/.openclaw/workspace-${agent}`;
  
  console.log(`📁 Creating workspace at ${workspace}...`);
  
  // 创建目录结构
  const dirs = [
    'memory',
    'life/archives/solutions',
    'life/archives/weekly',
    'life/archives/daily',
    'life/decisions',
    'life/motivation',
    'work/plans',
    'work/brainstorms',
    'work/todos',
    'docs',
    'para-system',
    'todos'
  ];
  
  for (const dir of dirs) {
    fs.mkdirpSync(`${workspace}/${dir}`);
  }
  
  // 复制模板文件
  const templates = {
    'templates/MEMORY.md.tmpl': 'MEMORY.md',
    'templates/HEARTBEAT.md.tmpl': 'HEARTBEAT.md',
    'templates/achievements.json.tmpl': 'life/motivation/achievements.json',
    'templates/.compound-memory.json.tmpl': '.compound-memory.json'
  };
  
  for (const [src, dest] of Object.entries(templates)) {
    fs.copyFileSync(src, `${workspace}/${dest}`);
  }
  
  console.log("✅ Workspace created");
}
```

#### Step 4: 创建软链接

```javascript
async function createSymlinks(agent, customPath) {
  const workspace = customPath || `${process.env.HOME}/.openclaw/workspace-${agent}`;
  
  console.log("🔗 Creating symlinks...");
  
  const symlinks = [
    { from: '../life/archives/solutions', to: 'docs/solutions' },
    { from: '../work/plans', to: 'docs/plans' },
    { from: '../work/brainstorms', to: 'docs/brainstorms' }
  ];
  
  for (const { from, to } of symlinks) {
    const target = `${workspace}/${to}`;
    if (fs.existsSync(target)) {
      fs.removeSync(target);
    }
    fs.symlinkSync(from, target);
  }
  
  console.log("✅ Symlinks created");
}
```

#### Step 5: 配置 Cron

```javascript
async function setupCron(agent) {
  console.log("⏰ Setting up cron jobs...");
  
  // 使用 OpenClaw 的 cron API
  const jobs = [
    {
      name: `${agent} 检查点提取`,
      schedule: { kind: 'every', everyMs: 21600000 },
      payload: { kind: 'agentTurn', message: '...' }
    },
    {
      name: `${agent} 模式提取`,
      schedule: { kind: 'cron', expr: '0 2 * * 0', tz: 'Asia/Shanghai' },
      payload: { kind: 'agentTurn', message: '...' }
    }
    // ...
  ];
  
  // 调用 OpenClaw API 创建 cron 任务
  // ...
  
  console.log("✅ Cron jobs configured");
}
```

## 六、配置文件

### .compound-memory.json

```json
{
  "version": "1.0.0",
  "agent": "baba",
  "components": {
    "cePlugin": {
      "version": "2.38.1",
      "installedAt": "2026-03-03",
      "updatePolicy": "track-upstream"
    },
    "intelligentMemory": {
      "version": "2.0",
      "installedAt": "2026-03-03",
      "updatePolicy": "self-maintained"
    }
  },
  "symlinks": {
    "docs/solutions": "life/archives/solutions",
    "docs/plans": "work/plans",
    "docs/brainstorms": "work/brainstorms"
  },
  "cron": {
    "checkpoint": { "enabled": true, "interval": "6h" },
    "pattern": { "enabled": true, "schedule": "0 2 * * 0" },
    "knowledge": { "enabled": true, "schedule": "30 2 * * 0" },
    "optimize": { "enabled": true, "schedule": "0 3 * * 0" }
  }
}
```

## 七、更新机制

### 更新 CE Plugin

```bash
# 更新 CE Plugin（不影响配置）
npx compound-memory-framework --update-ce

# 或手动
bunx @every-env/compound-plugin install compound-engineering --to openclaw
```

### 更新框架配置

```bash
# 更新框架（模板、脚本）
npx compound-memory-framework --update-framework --agent baba
```

## 八、发布方案

### npm 发布

```json
{
  "name": "compound-memory-framework",
  "version": "1.0.0",
  "description": "CE Plugin + Intelligent Memory fusion framework for OpenClaw",
  "bin": {
    "compound-memory-init": "./bin/compound-memory-init"
  },
  "files": [
    "bin",
    "lib",
    "templates"
  ],
  "keywords": [
    "openclaw",
    "compound-engineering",
    "intelligent-memory",
    "ai-agent"
  ],
  "license": "MIT"
}
```

### GitHub 发布

```bash
# 发布到 GitHub
git tag v1.0.0
git push origin v1.0.0

# 发布到 npm
npm publish
```

## 九、使用示例

### 安装

```bash
# 为新 agent 安装
npx compound-memory-framework --agent new-agent

# 输出：
# 🚀 Installing Compound Memory Framework...
# 📦 Installing CE Plugin...
# ✅ CE Plugin installed
# 📁 Creating workspace at ~/.openclaw/workspace-new-agent...
# ✅ Workspace created
# 🔗 Creating symlinks...
# ✅ Symlinks created
# ⏰ Setting up cron jobs...
# ✅ Cron jobs configured
# ✅ Installation complete!
#    Workspace: ~/.openclaw/workspace-new-agent
```

### 使用

```bash
# 进入 agent
cd ~/.openclaw/workspace-new-agent

# 使用 CE Plugin 命令
/ce:plan my-feature
/ce:work
/ce:review
/ce:compound

# 一键全流程
/lfg my-feature

# 检查点自动运行（每 6h）
# 模式发现自动运行（每周日）
```

---

**创建时间**: 2026-03-03
**作者**: 巴巴（架构师）🐢
**版本**: 1.0.0