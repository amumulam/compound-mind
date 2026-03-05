#!/bin/bash
# Compound Memory Framework 全面测试方案
# 测试时间: 2026-03-04
# 测试次数: 每组 30 次

set -e

TEST_WORKSPACE="/tmp/cmf-test-$(date +%s)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PASS=0
FAIL=0
TOTAL=0

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass() { echo -e "${GREEN}✅ PASS${NC}: $1"; ((PASS++)); ((TOTAL++)); }
fail() { echo -e "${RED}❌ FAIL${NC}: $1"; ((FAIL++)); ((TOTAL++)); }
warn() { echo -e "${YELLOW}⚠️  WARN${NC}: $1"; }
section() { echo ""; echo "========================================"; echo "  $1"; echo "========================================"; }

# ============================================
# 测试 1: 安装流程
# ============================================
test_install() {
    section "测试 1: 安装流程"
    
    echo "1.1 检查 CLI 入口..."
    if [ -f "$SCRIPT_DIR/bin/compound-memory-init" ]; then
        pass "CLI 入口存在"
    else
        fail "CLI 入口不存在"
    fi
    
    echo "1.2 执行安装..."
    export HTTP_PROXY=http://127.0.0.1:7890
    export HTTPS_PROXY=http://127.0.0.1:7890
    
    if node "$SCRIPT_DIR/bin/compound-memory-init" --agent test-agent --path "$TEST_WORKSPACE" --skip-cron --skip-git 2>&1 | grep -q "Installation complete"; then
        pass "安装成功完成"
    else
        fail "安装失败"
        return 1
    fi
    
    echo "1.3 检查安装日志..."
    if [ -d "$TEST_WORKSPACE" ]; then
        pass "Workspace 目录已创建: $TEST_WORKSPACE"
    else
        fail "Workspace 目录未创建"
    fi
}

# ============================================
# 测试 2: 目录结构
# ============================================
test_directory_structure() {
    section "测试 2: 目录结构"
    
    cd "$TEST_WORKSPACE"
    
    # 2.1 核心目录
    echo "2.1 检查核心目录..."
    for dir in memory life life/archives life/decisions life/motivation life/projects work para-system docs; do
        if [ -d "$dir" ]; then
            pass "目录存在: $dir"
        else
            fail "目录缺失: $dir"
        fi
    done
    
    # 2.2 life/projects 子目录
    echo "2.2 检查 life/projects 子目录..."
    for dir in pattern-extraction knowledge-validation nighttime-optimizer decision-logging motivation skill-dependency; do
        if [ -d "life/projects/$dir" ]; then
            pass "子目录存在: life/projects/$dir"
        else
            fail "子目录缺失: life/projects/$dir"
        fi
    done
    
    # 2.3 软链接
    echo "2.3 检查软链接..."
    for link in solutions plans brainstorms; do
        if [ -L "docs/$link" ]; then
            target=$(readlink "docs/$link")
            pass "软链接正确: docs/$link -> $target"
        else
            fail "软链接缺失: docs/$link"
        fi
    done
    
    # 2.4 不应该存在的目录
    echo "2.4 检查不应该存在的目录..."
    if [ ! -d "todos" ]; then
        pass "根目录 todos 不存在（正确）"
    else
        fail "根目录 todos 存在（应该删除）"
    fi
}

# ============================================
# 测试 3: 配置文件
# ============================================
test_config_files() {
    section "测试 3: 配置文件"
    
    cd "$TEST_WORKSPACE"
    
    echo "3.1 检查配置文件..."
    for file in MEMORY.md HEARTBEAT.md .compound-memory.json; do
        if [ -f "$file" ]; then
            pass "配置文件存在: $file"
        else
            fail "配置文件缺失: $file"
        fi
    done
    
    echo "3.2 检查 motivation 文件..."
    for file in life/motivation/achievements.json; do
        if [ -f "$file" ]; then
            pass "文件存在: $file"
        else
            fail "文件缺失: $file"
        fi
    done
    
    echo "3.3 验证 .compound-memory.json 格式..."
    if python3 -c "import json; json.load(open('.compound-memory.json'))" 2>/dev/null; then
        pass "JSON 格式正确"
    else
        fail "JSON 格式错误"
    fi
}

# ============================================
# 测试 4: 脚本文件
# ============================================
test_scripts() {
    section "测试 4: 脚本文件"
    
    cd "$TEST_WORKSPACE"
    
    echo "4.1 检查 Python 脚本..."
    for script in life/projects/pattern-extraction/weekly_pattern_extractor.py \
                  life/projects/knowledge-validation/knowledge-cleanup.py \
                  life/projects/nighttime-optimizer/nighttime_optimizer.py \
                  life/projects/decision-logging/decision_logger.py \
                  life/projects/motivation/motivation_tracker.py \
                  life/projects/skill-dependency/skill_dependency_analyzer.py; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            pass "脚本存在且可执行: $script"
        else
            fail "脚本问题: $script"
        fi
    done
    
    echo "4.2 检查 Shell 脚本..."
    for script in para-system/checkpoint-memory-llm.sh \
                  para-system/nightly-deep-analysis.sh; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            pass "脚本存在且可执行: $script"
        else
            fail "脚本问题: $script"
        fi
    done
}

# ============================================
# 测试 5: 脚本功能 (批量测试)
# ============================================
test_script_functions() {
    section "测试 5: 脚本功能 (每组 30 次)"
    
    cd "$TEST_WORKSPACE"
    
    # 准备测试数据
    mkdir -p memory life/decisions life/archives/weekly life/archives/solutions
    echo '{"decisions": [], "stats": {}}' > life/decisions/index.json
    echo '{}' > life/motivation/achievements.json
    echo '{"streaks": {}}' > life/motivation/streaks.json
    echo '{"milestones": {}}' > life/motivation/milestones.json
    echo "# 2026-03-04\n\n## 测试\n- 测试内容" > memory/2026-03-04.md
    
    # 5.1 decision_logger ID 唯一性
    echo "5.1 测试 decision_logger ID 唯一性 (30次)..."
    rm -f life/decisions/index.json life/decisions/*.json
    echo '{"decisions": [], "stats": {}}' > life/decisions/index.json
    
    IDS=""
    for i in $(seq 1 30); do
        ID=$(python3 life/projects/decision-logging/decision_logger.py create "测试$i" "测试" '["A","B"]' 0 "原因" 2>&1 | grep -oP 'dec-\d+-\d+')
        IDS="$IDS $ID"
    done
    UNIQUE_COUNT=$(echo $IDS | tr ' ' '\n' | sort -u | wc -l)
    if [ "$UNIQUE_COUNT" -eq 30 ]; then
        pass "decision_logger ID 唯一性: $UNIQUE_COUNT/30"
    else
        fail "decision_logger ID 重复: $UNIQUE_COUNT/30"
    fi
    
    # 5.2 knowledge-cleanup
    echo "5.2 测试 knowledge-cleanup (30次)..."
    SUCCESS=0
    for i in $(seq 1 30); do
        if python3 life/projects/knowledge-validation/knowledge-cleanup.py 2>&1 | grep -q "健康状态"; then
            ((SUCCESS++))
        fi
    done
    if [ "$SUCCESS" -eq 30 ]; then
        pass "knowledge-cleanup 稳定性: $SUCCESS/30"
    else
        fail "knowledge-cleanup 稳定性: $SUCCESS/30"
    fi
    
    # 5.3 pattern-extraction
    echo "5.3 测试 pattern-extraction (30次)..."
    SUCCESS=0
    for i in $(seq 1 30); do
        if python3 life/projects/pattern-extraction/weekly_pattern_extractor.py 2>&1 | grep -q "模式提取报告"; then
            ((SUCCESS++))
        fi
    done
    if [ "$SUCCESS" -eq 30 ]; then
        pass "pattern-extraction 稳定性: $SUCCESS/30"
    else
        fail "pattern-extraction 稳定性: $SUCCESS/30"
    fi
    
    # 5.4 nighttime-optimizer
    echo "5.4 测试 nighttime-optimizer (30次)..."
    SUCCESS=0
    for i in $(seq 1 30); do
        if python3 life/projects/nighttime-optimizer/nighttime_optimizer.py 2>&1 | grep -q "优化报告"; then
            ((SUCCESS++))
        fi
    done
    if [ "$SUCCESS" -eq 30 ]; then
        pass "nighttime-optimizer 稳定性: $SUCCESS/30"
    else
        fail "nighttime-optimizer 稳定性: $SUCCESS/30"
    fi
    
    # 5.5 motivation-tracker
    echo "5.5 测试 motivation-tracker (30次)..."
    SUCCESS=0
    for i in $(seq 1 30); do
        if python3 life/projects/motivation/motivation_tracker.py 2>&1 | grep -q "动机报告"; then
            ((SUCCESS++))
        fi
    done
    if [ "$SUCCESS" -eq 30 ]; then
        pass "motivation-tracker 稳定性: $SUCCESS/30"
    else
        fail "motivation-tracker 稳定性: $SUCCESS/30"
    fi
}

# ============================================
# 测试 6: 联动机制
# ============================================
test_integration() {
    section "测试 6: 联动机制"
    
    cd "$TEST_WORKSPACE"
    
    echo "6.1 测试软链接指向..."
    # 检查 docs/solutions 是否指向 life/archives/solutions
    SOLUTIONS_TARGET=$(readlink docs/solutions)
    if [ "$SOLUTIONS_TARGET" = "../life/archives/solutions" ]; then
        pass "docs/solutions 软链接正确"
    else
        fail "docs/solutions 软链接错误: $SOLUTIONS_TARGET"
    fi
    
    echo "6.2 测试写入 docs/solutions..."
    mkdir -p life/archives/solutions
    echo "test content" > docs/solutions/test.md
    if [ -f "life/archives/solutions/test.md" ]; then
        pass "写入 docs/solutions 成功映射到 life/archives/solutions"
    else
        fail "软链接映射失败"
    fi
    rm -f docs/solutions/test.md
    
    echo "6.3 测试检查点脚本读取逻辑..."
    # 创建测试数据
    echo "# 2026-03-04\n\n## 测试\n- 测试内容" > memory/2026-03-04.md
    echo "---\ntitle: 测试\n---\n\n## 解决方案\n内容" > life/archives/solutions/test.md
    
    # 检查脚本是否包含读取 solutions 的逻辑
    if grep -q "SOLUTIONS_DIR" para-system/checkpoint-memory-llm.sh; then
        pass "检查点脚本包含 solutions 读取逻辑"
    else
        fail "检查点脚本缺少 solutions 读取逻辑"
    fi
}

# ============================================
# 测试 7: CE Plugin 集成
# ============================================
test_ce_plugin() {
    section "测试 7: CE Plugin 集成"
    
    echo "7.1 检查 CE Plugin 安装..."
    if [ -d "/root/.openclaw/extensions/compound-engineering" ]; then
        pass "CE Plugin 已安装"
    else
        warn "CE Plugin 未安装（可能需要代理）"
    fi
    
    echo "7.2 检查 CE Plugin skills..."
    if [ -d "/root/.openclaw/extensions/compound-engineering/skills" ]; then
        SKILL_COUNT=$(ls /root/.openclaw/extensions/compound-engineering/skills 2>/dev/null | wc -l)
        pass "CE Plugin skills 数量: $SKILL_COUNT"
    else
        warn "CE Plugin skills 目录不存在"
    fi
}

# ============================================
# 测试 8: detect_workspace 功能
# ============================================
test_detect_workspace() {
    section "测试 8: detect_workspace 功能"
    
    cd "$TEST_WORKSPACE"
    
    echo "8.1 测试从子目录检测..."
    cd life/projects/pattern-extraction
    WORKSPACE_DETECTED=$(python3 -c "
import sys
sys.path.insert(0, '.')
from weekly_pattern_extractor import detect_workspace
print(detect_workspace())
" 2>/dev/null)
    
    if [ "$WORKSPACE_DETECTED" = "$TEST_WORKSPACE" ]; then
        pass "detect_workspace 从子目录正确检测: $WORKSPACE_DETECTED"
    else
        fail "detect_workspace 检测错误: $WORKSPACE_DETECTED (期望: $TEST_WORKSPACE)"
    fi
    
    cd "$TEST_WORKSPACE"
}

# ============================================
# 生成报告
# ============================================
generate_report() {
    section "测试报告"
    
    echo ""
    echo "=========================================="
    echo "  测试结果汇总"
    echo "=========================================="
    echo ""
    echo "总计测试: $TOTAL"
    echo -e "通过: ${GREEN}$PASS${NC}"
    echo -e "失败: ${RED}$FAIL${NC}"
    echo ""
    
    if [ "$FAIL" -eq 0 ]; then
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}  🎉 所有测试通过！评分: 100/100${NC}"
        echo -e "${GREEN}========================================${NC}"
    else
        SCORE=$((PASS * 100 / TOTAL))
        echo -e "${YELLOW}========================================${NC}"
        echo -e "${YELLOW}  评分: $SCORE/100${NC}"
        echo -e "${YELLOW}========================================${NC}"
    fi
    
    echo ""
    echo "测试 Workspace: $TEST_WORKSPACE"
    echo "测试时间: $(date '+%Y-%m-%d %H:%M:%S')"
}

# ============================================
# 主函数
# ============================================
main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     Compound Memory Framework 全面测试方案                 ║"
    echo "║     测试次数: 每组 30 次                                    ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    test_install
    test_directory_structure
    test_config_files
    test_scripts
    test_script_functions
    test_integration
    test_ce_plugin
    test_detect_workspace
    
    generate_report
    
    # 清理
    # rm -rf "$TEST_WORKSPACE"
}

main "$@"