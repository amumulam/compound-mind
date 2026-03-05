#!/bin/bash
# 功能: 深度分析+模式提取+主动优化
# 频率: 每周日 3:00
# 输出: 综合分析报告

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
REPORT_DIR="$WORKSPACE/para-system"
REPORT_FILE="$REPORT_DIR/nightly-analysis-report-$(date +%Y%m%d).md"

echo "# 夜间深度分析报告" > "$REPORT_FILE"
echo "生成时间: $(date '+%Y-%m-%d %H:%M')" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 1. 模式提取
if [ -f "$WORKSPACE/life/projects/pattern-extraction/weekly_pattern_extractor.py" ]; then
    echo "## 模式提取" >> "$REPORT_FILE"
    python3 "$WORKSPACE/life/projects/pattern-extraction/weekly_pattern_extractor.py" 7 >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
fi

# 2. 夜间优化
if [ -f "$WORKSPACE/life/projects/nighttime-optimizer/nighttime_optimizer.py" ]; then
    echo "## 系统优化" >> "$REPORT_FILE"
    python3 "$WORKSPACE/life/projects/nighttime-optimizer/nighttime_optimizer.py" >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
fi

# 3. 知识验证
if [ -f "$WORKSPACE/life/projects/knowledge-validation/knowledge-cleanup.py" ]; then
    echo "## 知识验证" >> "$REPORT_FILE"
    python3 "$WORKSPACE/life/projects/knowledge-validation/knowledge-cleanup.py" >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
fi

echo "Report generated: $REPORT_FILE"