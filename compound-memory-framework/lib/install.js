const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const TEMPLATES_DIR = path.join(__dirname, '..', 'templates');

/**
 * 安装融合框架
 */
async function install(options) {
  const { agent, path: customPath, skipCron, skipGit } = options;
  const workspace = customPath || getDefaultWorkspace(agent);
  
  console.log('🚀 Installing Compound Memory Framework...\n');
  
  // Step 1: 检查环境
  checkEnvironment();
  
  // Step 2: 安装 CE Plugin
  await installCEPlugin();
  
  // Step 3: 创建 Workspace
  await createWorkspace(workspace, agent);
  
  // Step 4: 创建软链接
  await createSymlinks(workspace);
  
  // Step 5: 配置 Cron
  if (!skipCron) {
    await setupCron(agent, workspace);
  }
  
  // Step 6: 初始化 Git
  if (!skipGit) {
    await initGit(workspace);
  }
  
  console.log('\n✅ Installation complete!\n');
  console.log(`   Workspace: ${workspace}`);
  console.log('\nUsage:');
  console.log('  /ce:plan    - Research and planning');
  console.log('  /ce:work    - Execute work');
  console.log('  /ce:review  - Multi-perspective review');
  console.log('  /ce:compound - Document solutions');
  console.log('  /lfg        - Full autonomous workflow');
  console.log('\n🐢 Compound Memory Framework');
}

/**
 * 获取默认 workspace 路径
 */
function getDefaultWorkspace(agent) {
  return path.join(process.env.HOME, '.openclaw', `workspace-${agent}`);
}

/**
 * 检查环境
 */
function checkEnvironment() {
  console.log('📋 Checking environment...');
  
  // 检查 OpenClaw
  const openclawDir = path.join(process.env.HOME, '.openclaw');
  if (!fs.existsSync(openclawDir)) {
    throw new Error('OpenClaw not found. Please install OpenClaw first.');
  }
  
  console.log('   ✅ OpenClaw found');
}

/**
 * 安装 CE Plugin
 */
async function installCEPlugin() {
  console.log('\n📦 Installing CE Plugin...');
  
  try {
    // 检查 bun
    try {
      execSync('bun --version', { stdio: 'ignore' });
    } catch {
      console.log('   Installing bun...');
      execSync('curl -fsSL https://bun.sh/install | bash', { stdio: 'inherit' });
    }
    
    // 安装 CE Plugin
    execSync('bunx @every-env/compound-plugin install compound-engineering --to openclaw', { 
      stdio: 'inherit' 
    });
    
    console.log('   ✅ CE Plugin installed');
  } catch (error) {
    console.log('   ⚠️  CE Plugin installation failed, but continuing...');
    console.log('   You can install it manually later:');
    console.log('   bunx @every-env/compound-plugin install compound-engineering --to openclaw');
  }
}

/**
 * 创建 Workspace
 */
async function createWorkspace(workspace, agent) {
  console.log(`\n📁 Creating workspace at ${workspace}...`);
  
  // 创建目录结构
  const dirs = [
    'memory',
    'life/archives/solutions',
    'life/archives/weekly',
    'life/archives/daily',
    'life/decisions',
    'life/motivation',
    'life/projects/pattern-extraction',
    'life/projects/knowledge-validation',
    'life/projects/nighttime-optimizer',
    'life/projects/decision-logging',
    'life/projects/motivation',
    'work/plans',
    'work/brainstorms',
    'work/todos',
    'docs',
    'para-system',
    'todos'
  ];
  
  for (const dir of dirs) {
    const fullPath = path.join(workspace, dir);
    fs.mkdirSync(fullPath, { recursive: true });
  }
  
  // 复制模板文件
  copyTemplate('MEMORY.md.tmpl', path.join(workspace, 'MEMORY.md'), { agent });
  copyTemplate('HEARTBEAT.md.tmpl', path.join(workspace, 'HEARTBEAT.md'));
  copyTemplate('achievements.json.tmpl', path.join(workspace, 'life', 'motivation', 'achievements.json'), { agent });
  copyTemplate('.compound-memory.json.tmpl', path.join(workspace, '.compound-memory.json'), { agent });
  
  console.log('   ✅ Workspace created');
}

/**
 * 复制模板文件
 */
function copyTemplate(templateName, targetPath, variables = {}) {
  const templatePath = path.join(TEMPLATES_DIR, templateName);
  
  if (!fs.existsSync(templatePath)) {
    // 如果模板不存在，使用默认内容
    const defaultContent = getDefaultTemplate(templateName, variables);
    fs.writeFileSync(targetPath, defaultContent);
    return;
  }
  
  let content = fs.readFileSync(templatePath, 'utf8');
  
  // 替换变量
  for (const [key, value] of Object.entries(variables)) {
    content = content.replace(new RegExp(`\\{\\{${key}\\}\\}`, 'g'), value);
  }
  
  fs.writeFileSync(targetPath, content);
}

/**
 * 获取默认模板
 */
function getDefaultTemplate(templateName, variables = {}) {
  const agent = variables.agent || 'agent';
  
  switch (templateName) {
    case 'MEMORY.md.tmpl':
      return `# MEMORY.md - 长期记忆

## 主人信息

- **称呼**: 主人

## 我的身份

- **名字**: ${agent}

## 重要事件

## 学到的经验

## 决策记录

| 日期 | 决策 | 文件 |
|------|------|------|
`;
    
    case 'HEARTBEAT.md.tmpl':
      return `# HEARTBEAT.md

## 心跳任务

每次心跳时按顺序检查：

### 1. 检查点提取

读取 \`memory/YYYY-MM-DD.md\`（今天），提取：

**决策类** → 记录到 \`life/decisions/\` 和 MEMORY.md
**学习类** → 记录到 MEMORY.md
**重要事件** → 记录到 MEMORY.md
**成就类** → 更新 \`life/motivation/achievements.json\`

---

如果以上任务都已完成或无需处理，回复 HEARTBEAT_OK。
`;
    
    case 'achievements.json.tmpl':
      return JSON.stringify({
        achievements: {},
        stats: { totalAchievements: 0, totalPoints: 0 }
      }, null, 2);
    
    case '.compound-memory.json.tmpl':
      return JSON.stringify({
        version: '1.0.0',
        agent: agent,
        components: {
          cePlugin: { version: 'latest', installedAt: new Date().toISOString().split('T')[0] },
          intelligentMemory: { version: '2.0', installedAt: new Date().toISOString().split('T')[0] }
        },
        symlinks: {
          'docs/solutions': 'life/archives/solutions',
          'docs/plans': 'work/plans',
          'docs/brainstorms': 'work/brainstorms'
        }
      }, null, 2);
    
    default:
      return '';
  }
}

/**
 * 创建软链接
 */
async function createSymlinks(workspace) {
  console.log('\n🔗 Creating symlinks...');
  
  const docsDir = path.join(workspace, 'docs');
  
  const symlinks = [
    { target: '../life/archives/solutions', link: path.join(docsDir, 'solutions') },
    { target: '../work/plans', link: path.join(docsDir, 'plans') },
    { target: '../work/brainstorms', link: path.join(docsDir, 'brainstorms') }
  ];
  
  for (const { target, link } of symlinks) {
    // 删除已存在的文件或链接
    if (fs.existsSync(link)) {
      fs.rmSync(link, { recursive: true, force: true });
    }
    
    // 创建软链接
    fs.symlinkSync(target, link);
  }
  
  console.log('   ✅ Symlinks created');
}

/**
 * 配置 Cron 任务
 */
async function setupCron(agent, workspace) {
  console.log('\n⏰ Setting up cron jobs...');
  
  // Cron 任务配置说明
  // 实际配置需要调用 OpenClaw 的 cron API
  
  const cronJobs = [
    { name: `${agent} 检查点提取`, schedule: '每 6 小时' },
    { name: `${agent} 模式提取`, schedule: '每周日 02:00' },
    { name: `${agent} 知识验证`, schedule: '每周日 02:30' },
    { name: `${agent} 夜间优化`, schedule: '每周日 03:00' }
  ];
  
  console.log('   Cron jobs to configure:');
  for (const job of cronJobs) {
    console.log(`   - ${job.name}: ${job.schedule}`);
  }
  
  console.log('\n   ⚠️  Manual setup required: Use OpenClaw cron API to create these jobs');
  console.log('   See: https://docs.openclaw.ai/tools/cron');
}

/**
 * 初始化 Git
 */
async function initGit(workspace) {
  console.log('\n📝 Initializing git...');
  
  try {
    execSync('git init', { cwd: workspace, stdio: 'ignore' });
    execSync('git add -A', { cwd: workspace, stdio: 'ignore' });
    execSync('git commit -m "Initial commit: Compound Memory Framework"', { 
      cwd: workspace, 
      stdio: 'ignore' 
    });
    console.log('   ✅ Git initialized');
  } catch {
    console.log('   ⚠️  Git initialization skipped');
  }
}

module.exports = install;