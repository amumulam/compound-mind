#!/usr/bin/env python3
"""
Compound Mind Cron 任务创建脚本

根据 compound-mind.config.json 创建 Cron 任务。

用法：
    python3 create_cron_tasks.py compound-mind.config.json
"""

import json
import subprocess
import sys
from pathlib import Path


def task_exists(task_name):
    """检查任务是否已存在"""
    result = subprocess.run(
        ['openclaw', 'cron', 'list', '--json'],
        capture_output=True,
        text=True
    )
    
    if result.returncode != 0:
        print(f"⚠️  无法获取任务列表：{result.stderr}")
        return False
    
    try:
        jobs = json.loads(result.stdout)
        if isinstance(jobs, dict) and 'jobs' in jobs:
            jobs = jobs['jobs']
        
        for job in jobs:
            if isinstance(job, dict) and job.get('name') == task_name:
                return True
    except json.JSONDecodeError:
        pass
    
    return False


def create_task(task_name, task_config):
    """创建单个 Cron 任务"""
    print(f"⏰ 创建任务：{task_name}")
    
    # 构建命令
    cmd = [
        'openclaw', 'cron', 'add',
        '--name', task_config['name'],
        '--agent', 'baba',
        '--session', 'isolated',
        '--message', task_config['payload']['message'],
        '--model', task_config['payload'].get('model', 'default'),
        '--timeout-seconds', str(task_config['payload'].get('timeoutSeconds', 300))
    ]
    
    # 添加调度参数
    schedule = task_config['schedule']
    if schedule.startswith('every'):
        # every 6h 格式
        cmd.extend(['--every', schedule.replace('every ', '')])
    else:
        # cron 表达式
        cmd.extend(['--cron', schedule])
    
    # 执行命令
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print(f"❌ 创建任务 {task_name} 失败：{result.stderr}")
        return False
    else:
        print(f"✅ 创建任务 {task_name} 成功")
        return True


def main():
    if len(sys.argv) != 2:
        print("用法：python3 create_cron_tasks.py <config.json>")
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
    
    # 检查任务
    tasks = config.get('tasks', {})
    if not tasks:
        print("❌ 配置文件中没有任务定义")
        sys.exit(1)
    
    print(f"📋 准备创建 {len(tasks)} 个任务...")
    print()
    
    # 创建任务
    success_count = 0
    skip_count = 0
    error_count = 0
    
    for task_name, task_config in tasks.items():
        # 检查是否已存在
        if task_exists(task_config['name']):
            print(f"⏭️  跳过任务 {task_name} (已存在)")
            skip_count += 1
            continue
        
        # 创建任务
        if create_task(task_name, task_config):
            success_count += 1
        else:
            error_count += 1
    
    # 输出汇总
    print()
    print("📊 创建完成:")
    print(f"  - 成功：{success_count}")
    print(f"  - 跳过：{skip_count}")
    print(f"  - 失败：{error_count}")
    
    if error_count > 0:
        sys.exit(1)
    else:
        sys.exit(0)


if __name__ == '__main__':
    main()
