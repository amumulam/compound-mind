#!/usr/bin/env python3
"""
Compound Mind 配置验证脚本

验证 compound-mind.config.json 的质量和完整性。

用法：
    python3 validate_config.py compound-mind.config.json
"""

import json
import sys
from pathlib import Path


def validate_structure(config):
    """验证配置文件结构"""
    errors = []
    
    # 检查必需字段
    required_fields = ['version', 'name', 'tasks']
    for field in required_fields:
        if field not in config:
            errors.append(f"缺少必需字段：{field}")
    
    # 检查 version 格式
    if 'version' in config:
        version = config['version']
        if not isinstance(version, str) or not version.count('.') >= 1:
            errors.append(f"version 格式错误：{version} (应该是 x.y.z 格式)")
    
    return errors


def validate_task(name, task):
    """验证单个任务配置"""
    errors = []
    
    # 检查必需字段
    required_fields = ['name', 'schedule', 'payload']
    for field in required_fields:
        if field not in task:
            errors.append(f"任务 {name} 缺少必需字段：{field}")
    
    # 检查 payload 结构
    if 'payload' in task:
        payload = task['payload']
        
        # 检查 message
        if 'message' not in payload:
            errors.append(f"任务 {name} 缺少 payload.message")
        else:
            message = payload['message']
            
            # 检查是否明确指定命令
            if 'openclaw cron' not in message.lower() and '读取' not in message and '写入' not in message:
                errors.append(f"任务 {name} payload 未明确指定操作命令")
            
            # 检查是否有输入定义
            if '输入' not in message and '读取' not in message:
                errors.append(f"任务 {name} payload 未定义输入")
            
            # 检查是否有输出定义
            if '输出' not in message and '写入' not in message:
                errors.append(f"任务 {name} payload 未定义输出")
            
            # 检查是否有判断标准
            if '判断' not in message and '如果' not in message:
                errors.append(f"任务 {name} payload 未定义判断标准")
        
        # 检查 model
        if 'model' not in payload:
            errors.append(f"任务 {name} 缺少 payload.model")
        
        # 检查 timeoutSeconds
        if 'timeoutSeconds' not in payload:
            errors.append(f"任务 {name} 缺少 payload.timeoutSeconds")
    
    # 检查 validation 规则
    if 'validation' not in task:
        errors.append(f"任务 {name} 缺少 validation 规则")
    else:
        validation = task['validation']
        
        if 'requiredCommands' not in validation:
            errors.append(f"任务 {name} 缺少 validation.requiredCommands")
        
        if 'expectedOutputs' not in validation:
            errors.append(f"任务 {name} 缺少 validation.expectedOutputs")
        
        if 'forbiddenPatterns' not in validation:
            errors.append(f"任务 {name} 缺少 validation.forbiddenPatterns")
    
    return errors


def validate_metadata(config):
    """验证 metadata 字段"""
    errors = []
    
    if 'metadata' in config:
        metadata = config['metadata']
        
        if 'createdAt' not in metadata:
            errors.append("缺少 metadata.createdAt")
        
        if 'updatedAt' not in metadata:
            errors.append("缺少 metadata.updatedAt")
    
    return errors


def main():
    if len(sys.argv) != 2:
        print("用法：python3 validate_config.py <config.json>")
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
    
    # 验证
    all_errors = []
    
    # 1. 验证结构
    structure_errors = validate_structure(config)
    all_errors.extend(structure_errors)
    
    # 2. 验证每个任务
    if 'tasks' in config:
        for task_name, task in config['tasks'].items():
            task_errors = validate_task(task_name, task)
            all_errors.extend(task_errors)
    
    # 3. 验证 metadata
    metadata_errors = validate_metadata(config)
    all_errors.extend(metadata_errors)
    
    # 输出结果
    if all_errors:
        print("❌ 配置验证失败:")
        for error in all_errors:
            print(f"  - {error}")
        print(f"\n共发现 {len(all_errors)} 个问题")
        sys.exit(1)
    else:
        print("✅ 配置验证通过")
        print(f"  - 版本：{config.get('version', '未知')}")
        print(f"  - 任务数：{len(config.get('tasks', {}))}")
        print(f"  - 所有任务都有完整的 payload 和 validation 规则")
        sys.exit(0)


if __name__ == '__main__':
    main()
