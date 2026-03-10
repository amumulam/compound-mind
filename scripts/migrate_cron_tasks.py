#!/usr/bin/env python3
"""
Compound Mind Cron 任务迁移脚本

更新现有 Cron 任务的 payload 以匹配 config.json。

用法：
    python3 migrate_cron_tasks.py compound-mind.config.json
"""

import json
import subprocess
import sys
from pathlib import Path


def get_cron_tasks():
    """获取所有 Cron 任务"""
    result = subprocess.run(
        ['openclaw', 'cron', 'list', '--json'],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        return None
    
    try:
        data = json.loads(result.stdout)
        if isinstance(data, dict) and 'jobs' in data:
            return data['jobs']
        elif isinstance(data, list):
            return data
    except json.JSONDecodeError:
        pass
    
    return None


def get_task_id(task_name, tasks):
    """获取任务 ID"""
    for task in tasks:
        if isinstance(task, dict) and task.get('name') == task_name:
            return task.get('id')
    return None


def update_task(task_id, task_config):
    """更新单个任务"""
    task_name = task_config['name']
    print(f"⏰ 更新任务：{task_name}")
    
    # 构建命令
    cmd = [
        'openclaw', 'cron', 'edit',
        task_id,
        '--message', task_config['payload']['message'],
        '--model', task_config['payload'].get('model', 'default'),
        '--timeout-seconds', str(task_config['payload'].get('timeoutSeconds', 300))
    ]
    
    # 执行命令
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print(f"❌ 更新任务 {task_name} 失败：{result.stderr}")
        return False
    else:
        print(f"✅ 更新任务 {task_name} 成功")
        return True


def main():
    if len(sys.argv) != 2:
        print("用法：python3 migrate_cron_tasks.py <config.json>")
        sys.exit(1)
    
    config_file = sys.argv[1]
    config_path = Path(config_file)
    
    if not config_path.exists():
        print(f"❌ 配置文件不存在：{config_file}")
        sys.exit(1)
    
    # 读取配置
    try:
        with open(config_file, 'r', encoding='utf-8') as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        print(f"❌ JSON 解析失败：{e}")
        sys.exit(1)
    
    # 获取实际任务
    print("📋 获取 Cron 任务列表...")
    actual_tasks = get_cron_tasks()
    
    if actual_tasks is None:
        print("❌ 无法获取 Cron 任务列表")
        sys.exit(1)
    
    # 迁移任务
    tasks = config.get('tasks', {})
    print(f"📋 准备迁移 {len(tasks)} 个任务...")
    print()
    
    success_count = 0
    skip_count = 0
    error_count = 0
    
    for task_name, task_config in tasks.items():
        expected_name = task_config['name']
        task_id = get_task_id(expected_name, actual_tasks)
        
        if not task_id:
            print(f"⏭️  跳过任务 {task_name} (不存在，需要创建)")
            skip_count += 1
            continue
        
        # 更新任务
        if update_task(task_id, task_config):
            success_count += 1
        else:
            error_count += 1
    
    # 输出汇总
    print()
    print("📊 迁移完成:")
    print(f"  - 成功：{success_count}")
    print(f"  - 跳过：{skip_count}")
    print(f"  - 失败：{error_count}")
    
    if error_count > 0:
        sys.exit(1)
    else:
        print()
        print("✅ 所有任务已迁移到最新配置")
        sys.exit(0)


if __name__ == '__main__':
    main()
