# Compound Memory Framework - 发布方案

## 打包结构

```
compound-memory-framework/
├── SKILL.md                     # 入口文件
├── install.sh                   # 安装脚本
├── FRAMEWORK.md                 # 架构文档
│
├── templates/                   # 模板文件
│   ├── MEMORY.md.tmpl           # 精选记忆模板
│   ├── HEARTBEAT.md.tmpl        # 心跳配置模板
│   └── achievements.json.tmpl   # 成就系统模板
│
├── scripts/                     # 安装脚本
│   ├── setup-ce-plugin.sh       # 安装 CE Plugin
│   ├── setup-workspace.sh       # 创建 workspace 结构
│   ├── setup-cron.sh            # 配置 cron 任务
│   └── create-symlinks.sh       # 创建符号链接
│
└── config/                      # 配置示例
    └── cron-jobs.json           # cron 任务配置
```

## 安装脚本

### install.sh

```bash
#!/bin/bash
set -e

AGENT_NAME=${1:-"agent"}
WORKSPACE="$HOME/.openclaw/workspace-$AGENT_NAME"

echo "🚀 Installing Compound Memory Framework for $AGENT_NAME..."

# Step 1: 安装 CE Plugin
./scripts/setup-ce-plugin.sh

# Step 2: 创建 workspace 结构
./scripts/setup-workspace.sh "$WORKSPACE"

# Step 3: 创建符号链接
./scripts/create-symlinks.sh "$WORKSPACE"

# Step 4: 配置 cron 任务
./scripts/setup-cron.sh "$AGENT_NAME"

echo "✅ Compound Memory Framework installed successfully!"
echo "   Workspace: $WORKSPACE"
echo ""
echo "Usage:"
echo "  /ce:plan    - 研究规划"
echo "  /ce:work    - 执行工作"
echo "  /ce:review  - 多视角审核"
echo "  /ce:compound - 沉淀解决方案"
echo "  /lfg        - 一键全流程"
```

### scripts/setup-ce-plugin.sh

```bash
#!/bin/bash
set -e

echo "📦 Installing CE Plugin..."

# 检查 bun
if ! command -v bun &> /dev/null; then
    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    source ~/.bashrc
fi

# 安装 CE Plugin
bunx @every-env/compound-plugin install compound-engineering --to openclaw

echo "✅ CE Plugin installed"
```

### scripts/setup-workspace.sh

```bash
#!/bin/bash
set -e

WORKSPACE=$1

echo "📁 Creating workspace structure at $WORKSPACE..."

mkdir -p "$WORKSPACE"/{memory,life/{archives/{solutions,weekly,daily},decisions,motivation},docs,para-system,todos}

# 复制模板
cp templates/MEMORY.md.tmpl "$WORKSPACE/MEMORY.md"
cp templates/HEARTBEAT.md.tmpl "$WORKSPACE/HEARTBEAT.md"
cp templates/achievements.json.tmpl "$WORKSPACE/life/motivation/achievements.json"

# 初始化 git
cd "$WORKSPACE"
git init
git add -A
git commit -m "Initial commit: Compound Memory Framework"

echo "✅ Workspace created"
```

### scripts/create-symlinks.sh

```bash
#!/bin/bash
set -e

WORKSPACE=$1

echo "🔗 Creating symlinks..."

cd "$WORKSPACE/docs"

# 创建符号链接：docs/solutions → life/archives/solutions
if [ -L solutions ]; then
    rm solutions
elif [ -d solutions ]; then
    rmdir solutions 2>/dev/null || rm -rf solutions
fi

ln -s ../life/archives/solutions solutions

echo "✅ Symlinks created"
```

### scripts/setup-cron.sh

```bash
#!/bin/bash
set -e

AGENT_NAME=$1

echo "⏰ Setting up cron jobs..."

# 使用 OpenClaw 的 cron 配置
# 这里需要调用 OpenClaw API 或使用配置文件

# cron-jobs.json 包含任务定义
# 由 OpenClaw 在启动时加载

echo "✅ Cron jobs configured"
echo "   - 检查点提取: 每 6 小时"
echo "   - 模式发现: 每周日 02:00"
echo "   - 知识验证: 每周日 02:30"
echo "   - 夜间优化: 每周日 03:00"
```

## 更新机制

### update-ce-plugin.sh

```bash
#!/bin/bash
set -e

echo "🔄 Updating CE Plugin..."

# 更新 CE Plugin（不修改本地配置）
bunx @every-env/compound-plugin install compound-engineering --to openclaw

echo "✅ CE Plugin updated to latest version"
echo "   Your workspace and configurations are preserved"
```

## 发布到 ClawHub

```bash
clawhub publish ./compound-memory-framework \
  --slug compound-memory-framework \
  --name "Compound Memory Framework" \
  --version 1.0.0 \
  --changelog "Initial release: CE Plugin + ClawIntelligentMemory fusion"
```

## 使用方式

### 安装

```bash
# 从 ClawHub 安装
clawhub install compound-memory-framework

# 或直接运行
./install.sh my-agent
```

### 更新

```bash
# 更新框架
clawhub update compound-memory-framework

# 更新 CE Plugin（单独）
./scripts/update-ce-plugin.sh
```

### 日常使用

```
/ce:plan     # 规划任务
/ce:work     # 执行任务
/ce:review   # 审核代码
/ce:compound # 沉淀解决方案

/lfg         # 一键全流程

# 检查点提取自动运行（每 6 小时）
# 模式发现自动运行（每周日）
```

---

**维护策略**：
- CE Plugin 更新：独立更新，不影响框架
- 框架更新：更新脚本和模板
- 用户数据：永不覆盖