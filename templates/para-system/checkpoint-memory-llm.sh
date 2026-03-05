#!/bin/bash
# 功能: LLM智能提取关键记忆，更新MEMORY.md
# 频率: 每6小时
# 输出: .../Space/MEMORY.md
# 联动: 读取 CE Plugin solutions/ + 每日日志

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
MEMORY_FILE="$WORKSPACE/MEMORY.md"
OLLAMA_URL="${OLLAMA_URL:-http://127.0.0.1:11434/api/generate}"
MODEL="${MODEL:-qwen3:latest}"

# 自动检测 workspace
if [ ! -f "$WORKSPACE/.compound-memory.json" ]; then
    # 从当前目录向上查找
    CURRENT_DIR=$(pwd)
    while [ "$CURRENT_DIR" != "/" ]; do
        if [ -f "$CURRENT_DIR/.compound-memory.json" ]; then
            WORKSPACE="$CURRENT_DIR"
            break
        fi
        CURRENT_DIR=$(dirname "$CURRENT_DIR")
    done
fi

# 1. 读取今日日志
TODAY=$(date +%Y-%m-%d)
DAILY_LOG="$WORKSPACE/memory/$TODAY.md"
DAILY_CONTENT=$(tail -150 "$DAILY_LOG" 2>/dev/null || echo "")

# 2. 读取最近的 CE Plugin solutions (最近24小时)
SOLUTIONS_DIR="$WORKSPACE/life/archives/solutions"
SOLUTIONS_CONTENT=""
if [ -d "$SOLUTIONS_DIR" ]; then
    # 查找最近24小时内修改的文件
    RECENT_SOLUTIONS=$(find "$SOLUTIONS_DIR" -name "*.md" -mtime -1 2>/dev/null | head -5)
    for sol_file in $RECENT_SOLUTIONS; do
        SOLUTIONS_CONTENT="$SOLUTIONS_CONTENT\n---\n### Solution: $(basename $sol_file)\n$(cat $sol_file 2>/dev/null | head -50)\n"
    done
fi

# 3. 合并内容
if [ -z "$DAILY_CONTENT" ] && [ -z "$SOLUTIONS_CONTENT" ]; then
    echo "No content to process"
    exit 0
fi

COMBINED_CONTENT="## 今日日志\n$DAILY_CONTENT\n\n## 最近的解决方案\n$SOLUTIONS_CONTENT"

# 4. 构建提示词
PROMPT="从以下内容中提取关键信息，用于更新长期记忆：

1. 今日成就（完成了什么重要事情）
2. 学习收获（学到了什么新知识/技能）
3. 重要决策（做了什么决定，为什么）
4. 解决的问题（用什么方法解决了什么问题）

内容：
$COMBINED_CONTENT"

# 5. 调用LLM
ESCAPED_PROMPT=$(python3 -c "import json; print(json.dumps('''$PROMPT'''))")
RESPONSE=$(curl -s "$OLLAMA_URL" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"$MODEL\",\"prompt\":$ESCAPED_PROMPT,\"stream\":false}")

SUMMARY=$(echo "$RESPONSE" | jq -r '.response // empty')

# 6. 更新MEMORY.md
if [ -n "$SUMMARY" ]; then
    # 备份
    if [ -f "$MEMORY_FILE" ]; then
        cp "$MEMORY_FILE" "$MEMORY_FILE.bak"
    fi
    
    cat >> "$MEMORY_FILE" << EOF

## 检查点 $(date '+%Y-%m-%d %H:%M')

$SUMMARY

---
EOF
    echo "✅ Checkpoint updated at $(date)"
    echo "   - 每日日志: $([ -n "$DAILY_CONTENT" ] && echo "✓" || echo "✗")"
    echo "   - CE Solutions: $([ -n "$SOLUTIONS_CONTENT" ] && echo "✓ ($(echo "$RECENT_SOLUTIONS" | wc -l) 个)" || echo "✗")"
else
    echo "No summary generated"
fi