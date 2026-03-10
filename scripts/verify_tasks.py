#!/usr/bin/env python3
"""
Compound Mind Cron 任务验证脚本

验证创建的任务是否与配置一致。

用法：
    python3 verify_tasks.py compound-mind.config.json
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


def verify_task(task_name, task_config, actual_task):
    """验证单个任务"""
    errors = []
    
    # 检查名称
    if actual_task.get('name') != task_config['name']:
        errors.append(f"名称不匹配：期望 {task_config['name']}, 实际 {actual_task.get('name')}")
    
    # 检查 payload message
    actual_payload = actual_task.get('payload', {})
    expected_message = task_config['payload']['message']
    actual_message = actual_payload.get('message', '')
    
    # 检查消息是否包含关键内容（不要求完全匹配）
    if len(expected_message) > 50:
        # 取前 50 个字符比较
        if expected_message[:50] not in actual_message:
            errors.append(f"payload message 不匹配")
    
    # 检查 model
    expected_model = task_config['payload'].get('model', 'default')
    actual_model = actual_payload.get('model', '')
    if expected_model and expected_model not in actual_model:
        errors.append(f"model 不匹配：期望 {expected_model}, 实际 {actual_model}")
    
    # 检查调度
    actual_schedule = actual_task.get('schedule', {})
    expected_schedule = task_config['schedule']
    
    if expected_schedule.startswith('every'):
        # every 6h 格式
        if actual_schedule.get('kind') != 'every':
            errors.append(f"调度类型不匹配：期望 every, 实际 {actual_schedule.get('kind')}")
    else:
        # cron 表达式
        if actual_schedule.get('expr') != expected_schedule:
            errors.append(f"cron 表达式不匹配：期望 {expected_schedule}, 实际 {actual_schedule.get('expr')}")
    
    return errors


def main():
    if len(sys.argv) != 2:
        print("用法：python3 verify_tasks.py <config.json>")
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
    
    # 创建任务名称索引
    task_index = {t.get('name'): t for t in actual_tasks if isinstance(t, dict)}
    
    # 验证每个任务
    tasks = config.get('tasks', {})
    all_errors = []
    verified_count = 0
    
    for task_name, task_config in tasks.items():
        expected_name = task_config['name']
        
        if expected_name not in task_index:
            all_errors.append(f"任务 {task_name} 不存在：{expected_name}")
            continue
        
        actual_task = task_index[expected_name]
        errors = verify_task(task_name, task_config, actual_task)
        
        if errors:
            all_errors.extend([f"任务 {task_name}: {e}" for e in errors])
        else:
            verified_count += 1
    
    # 输出结果
    print()
    if all_errors:
        print("❌ 任务验证失败:")
        for error in all_errors:
            print(f"  - {error}")
        print(f"\n验证通过：{verified_count}/{len(tasks)}")
        sys.exit(1)
    else:
        print("✅ 任务验证通过")
        print(f"  - 验证任务数：{verified_count}")
        print(f"  - 所有任务配置与 config.json 一致")
        sys.exit(0)


if __name__ == '__main__':
    main()
