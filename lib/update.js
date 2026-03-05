const { execSync } = require('child_process');

/**
 * 更新 CE Plugin
 */
async function cePlugin() {
  console.log('🔄 Updating CE Plugin...\n');
  
  try {
    execSync('bunx @every-env/compound-plugin install compound-engineering --to openclaw', { 
      stdio: 'inherit' 
    });
    
    console.log('\n✅ CE Plugin updated to latest version');
    console.log('   Your workspace and configurations are preserved');
  } catch (error) {
    console.error('❌ Failed to update CE Plugin:', error.message);
    throw error;
  }
}

/**
 * 更新框架模板
 */
async function framework(options) {
  const { agent, path: customPath } = options;
  const workspace = customPath || getDefaultWorkspace(agent);
  
  console.log('🔄 Updating framework templates...\n');
  console.log('⚠️  This feature is not yet implemented.');
  console.log('   For now, manually update your workspace files.');
}

function getDefaultWorkspace(agent) {
  const path = require('path');
  return path.join(process.env.HOME, '.openclaw', `workspace-${agent}`);
}

module.exports = {
  cePlugin,
  framework
};