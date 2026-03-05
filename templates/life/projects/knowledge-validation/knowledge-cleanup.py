#!/usr/bin/env python3
"""
知识验证 - 检测过时、孤立、重复内容
"""

import os
import re
import json
from datetime import datetime, timedelta
from collections import defaultdict
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

def check_memory_health(workspace):
    """检查记忆系统健康状态"""
    memory_file = os.path.join(workspace, 'MEMORY.md')
    
    issues = {
        'outdated': [],      # 过时内容
        'isolated': [],      # 孤立内容
        'duplicates': [],    # 重复内容
        'oversized': False   # MEMORY.md 过大
    }
    
    if not os.path.exists(memory_file):
        return issues
    
    with open(memory_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 检查大小
    if len(content) > 2500:
        issues['oversized'] = True
        issues['outdated'].append({
            'type': 'oversized',
            'message': f'MEMORY.md 大小 ({len(content)} 字符) 超过建议上限 (2500 字符)'
        })
    
    # 检查过时日期
    old_dates = re.findall(r'(\d{4}-\d{2}-\d{2})', content)
    for date_str in old_dates:
        try:
            date = datetime.strptime(date_str, '%Y-%m-%d')
            if (datetime.now() - date).days > 30:
                issues['outdated'].append({
                    'type': 'old_date',
                    'message': f'发现超过30天的日期: {date_str}'
                })
        except:
            pass
    
    # 检查重复内容
    lines = content.split('\n')
    seen = defaultdict(int)
    for line in lines:
        line = line.strip()
        if line and len(line) > 20:  # 只检查较长的行
            seen[line] += 1
            if seen[line] > 1:
                issues['duplicates'].append({
                    'type': 'duplicate_line',
                    'message': f'重复内容: {line[:50]}...'
                })
    
    return issues

def generate_cleanup_report(issues, output_file):
    """生成清理报告"""
    report = []
    report.append("# 知识验证报告")
    report.append(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    report.append("")
    
    # 过时内容
    if issues['outdated']:
        report.append("## 过时内容")
        for item in issues['outdated']:
            report.append(f"- [{item['type']}] {item['message']}")
        report.append("")
    
    # 重复内容
    if issues['duplicates']:
        report.append("## 重复内容")
        for item in issues['duplicates'][:10]:  # 只显示前10个
            report.append(f"- {item['message']}")
        report.append("")
    
    # 孤立内容
    if issues['isolated']:
        report.append("## 孤立内容")
        for item in issues['isolated']:
            report.append(f"- {item['message']}")
        report.append("")
    
    # 健康状态
    total_issues = len(issues['outdated']) + len(issues['duplicates']) + len(issues['isolated'])
    if issues['oversized']:
        total_issues += 1
    
    report.append("## 健康状态")
    if total_issues == 0:
        report.append("✅ 系统健康，无问题发现")
    else:
        report.append(f"⚠️ 发现 {total_issues} 个问题需要关注")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(report))
    
    return '\n'.join(report)

def main():
    workspace = detect_workspace()
    output_dir = os.path.join(workspace, 'life', 'archives')
    
    os.makedirs(output_dir, exist_ok=True)
    
    issues = check_memory_health(workspace)
    
    output_file = os.path.join(output_dir, f"cleanup-report-{datetime.now().strftime('%Y%m%d')}.md")
    report = generate_cleanup_report(issues, output_file)
    
    print(report)
    print(f"\n报告已保存: {output_file}")

if __name__ == '__main__':
    main()