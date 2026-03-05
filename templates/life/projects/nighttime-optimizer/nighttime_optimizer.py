#!/usr/bin/env python3
"""
夜间优化器 - 系统健康检查和自动修复
"""

import os
import shutil
import json
from datetime import datetime, timedelta
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

def check_disk_space(path, threshold=80):
    """检查磁盘空间"""
    total, used, free = shutil.disk_usage(path)
    used_percent = (used / total) * 100
    return {
        'used_percent': used_percent,
        'free_gb': free / (1024**3),
        'healthy': used_percent < threshold
    }

def check_memory_size(workspace, max_size=2500):
    """检查 MEMORY.md 大小"""
    memory_file = os.path.join(workspace, 'MEMORY.md')
    if not os.path.exists(memory_file):
        return {'exists': False, 'size': 0, 'healthy': True}
    
    size = os.path.getsize(memory_file)
    return {
        'exists': True,
        'size': size,
        'healthy': size <= max_size
    }

def check_temp_files(workspace, max_age_days=7):
    """检查临时文件"""
    temp_patterns = ['.tmp', '.bak', '.log', 'checkpoint-']
    temp_files = []
    
    for root, dirs, files in os.walk(workspace):
        for file in files:
            for pattern in temp_patterns:
                if pattern in file:
                    filepath = os.path.join(root, file)
                    mtime = datetime.fromtimestamp(os.path.getmtime(filepath))
                    age = (datetime.now() - mtime).days
                    if age > max_age_days:
                        temp_files.append({
                            'path': filepath,
                            'age_days': age
                        })
    
    return temp_files

def cleanup_temp_files(temp_files):
    """清理临时文件"""
    cleaned = 0
    for item in temp_files:
        try:
            os.remove(item['path'])
            cleaned += 1
        except Exception as e:
            print(f"清理失败: {item['path']} - {e}")
    return cleaned

def archive_memory_if_oversized(workspace, max_size=2500):
    """如果 MEMORY.md 过大则归档"""
    memory_file = os.path.join(workspace, 'MEMORY.md')
    if not os.path.exists(memory_file):
        return False
    
    size = os.path.getsize(memory_file)
    if size > max_size:
        # 创建归档
        archive_dir = os.path.join(workspace, 'life', 'archives')
        os.makedirs(archive_dir, exist_ok=True)
        
        archive_name = f"MEMORY-backup-{datetime.now().strftime('%Y%m%d-%H%M%S')}.md"
        archive_path = os.path.join(archive_dir, archive_name)
        
        shutil.copy(memory_file, archive_path)
        
        # 保留最近的部分
        with open(memory_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 保留前 max_size 字符
        with open(memory_file, 'w', encoding='utf-8') as f:
            f.write(content[:max_size])
            f.write("\n\n[已归档，完整内容见: " + archive_name + "]\n")
        
        return True
    
    return False

def generate_optimizer_report(results, output_file):
    """生成优化报告"""
    report = []
    report.append("# 夜间优化报告")
    report.append(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    report.append("")
    
    # 磁盘空间
    report.append("## 磁盘空间")
    disk = results['disk']
    status = "✅" if disk['healthy'] else "⚠️"
    report.append(f"{status} 使用率: {disk['used_percent']:.1f}%")
    report.append(f"剩余空间: {disk['free_gb']:.1f} GB")
    report.append("")
    
    # MEMORY.md
    report.append("## MEMORY.md")
    memory = results['memory']
    if memory['exists']:
        status = "✅" if memory['healthy'] else "⚠️"
        report.append(f"{status} 大小: {memory['size']} 字节")
        if results.get('archived'):
            report.append("📦 已自动归档")
    else:
        report.append("⚠️ 文件不存在")
    report.append("")
    
    # 临时文件
    report.append("## 临时文件")
    temp = results['temp_files']
    if temp:
        report.append(f"发现 {len(temp)} 个过期临时文件")
        if results.get('cleaned'):
            report.append(f"✅ 已清理 {results['cleaned']} 个文件")
    else:
        report.append("✅ 无过期临时文件")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(report))
    
    return '\n'.join(report)

def main():
    workspace = detect_workspace()
    
    results = {
        'disk': check_disk_space(workspace),
        'memory': check_memory_size(workspace),
        'temp_files': check_temp_files(workspace)
    }
    
    # 执行优化
    # 1. 清理临时文件
    if results['temp_files']:
        results['cleaned'] = cleanup_temp_files(results['temp_files'])
    
    # 2. 归档过大的 MEMORY.md
    if not results['memory']['healthy']:
        results['archived'] = archive_memory_if_oversized(workspace)
    
    # 生成报告
    output_dir = os.path.join(workspace, 'para-system')
    os.makedirs(output_dir, exist_ok=True)
    output_file = os.path.join(output_dir, f"optimizer-report-{datetime.now().strftime('%Y%m%d')}.md")
    report = generate_optimizer_report(results, output_file)
    
    print(report)

if __name__ == '__main__':
    main()