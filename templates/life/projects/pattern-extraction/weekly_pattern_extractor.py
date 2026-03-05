#!/usr/bin/env python3
"""
模式提取器 - 每周分析日志发现主题和规律
"""

import os
import json
import re
from datetime import datetime, timedelta
from collections import Counter
from pathlib import Path

def detect_workspace():
    """自动检测 workspace 目录"""
    if os.environ.get('WORKSPACE'):
        return os.environ.get('WORKSPACE')
    current = Path.cwd()
    for parent in [current] + list(current.parents):
        if (parent / '.compound-memory.json').exists():
            return str(parent)
    return os.path.expanduser('~/.openclaw/workspace')

def extract_patterns(memory_dir, days=7):
    """从最近N天的日志中提取模式"""
    patterns = {
        'topics': Counter(),
        'tools': Counter(),
        'problems': Counter(),
        'decisions': []
    }
    
    # 读取最近N天的日志
    for i in range(days):
        date = datetime.now() - timedelta(days=i)
        log_file = os.path.join(memory_dir, f"{date.strftime('%Y-%m-%d')}.md")
        
        if not os.path.exists(log_file):
            continue
            
        with open(log_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # 提取主题 (## 标题)
            topics = re.findall(r'^## (.+)$', content, re.MULTILINE)
            patterns['topics'].update(topics)
            
            # 提取工具使用 (工具名:)
            tools = re.findall(r'(\w+):', content)
            patterns['tools'].update(tools)
            
            # 提取问题关键词
            problems = re.findall(r'(问题|错误|失败|bug|修复)', content, re.IGNORECASE)
            patterns['problems'].update(problems)
            
            # 提取决策
            decisions = re.findall(r'(决定|选择|确认)[：:]\s*(.+)', content)
            patterns['decisions'].extend(decisions)
    
    return patterns

def generate_report(patterns, output_file):
    """生成模式报告"""
    report = []
    report.append("# 每周模式提取报告")
    report.append(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    report.append("")
    
    # 主题统计
    report.append("## 高频主题 (Top 10)")
    for topic, count in patterns['topics'].most_common(10):
        report.append(f"- {topic}: {count}次")
    report.append("")
    
    # 工具统计
    report.append("## 常用工具 (Top 10)")
    for tool, count in patterns['tools'].most_common(10):
        report.append(f"- {tool}: {count}次")
    report.append("")
    
    # 问题统计
    report.append("## 问题关键词")
    for problem, count in patterns['problems'].most_common(5):
        report.append(f"- {problem}: {count}次")
    report.append("")
    
    # 决策记录
    if patterns['decisions']:
        report.append("## 本周决策")
        for decision in patterns['decisions'][:10]:
            report.append(f"- {decision[0]}: {decision[1]}")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(report))
    
    return '\n'.join(report)

def main():
    workspace = detect_workspace()
    memory_dir = os.path.join(workspace, 'memory')
    output_dir = os.path.join(workspace, 'life', 'archives', 'weekly')
    
    os.makedirs(output_dir, exist_ok=True)
    
    patterns = extract_patterns(memory_dir)
    
    output_file = os.path.join(output_dir, f"weekly-report-{datetime.now().strftime('%Y-W%W')}.md")
    report = generate_report(patterns, output_file)
    
    print(report)
    print(f"\n报告已保存: {output_file}")

if __name__ == '__main__':
    import sys
    days = int(sys.argv[1]) if len(sys.argv) > 1 else 7
    main()