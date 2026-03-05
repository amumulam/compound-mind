#!/usr/bin/env python3
"""
决策日志 - 记录重要决策的背景、选项和原因
"""

import os
import json
from datetime import datetime
from pathlib import Path

DECISIONS_DIR = None
INDEX_FILE = None
WORKSPACE = None

def detect_workspace():
    """自动检测 workspace 目录"""
    # 1. 优先使用环境变量
    if os.environ.get('WORKSPACE'):
        return os.environ.get('WORKSPACE')
    
    # 2. 从当前目录向上查找 .compound-memory.json
    current = Path.cwd()
    for parent in [current] + list(current.parents):
        if (parent / '.compound-memory.json').exists():
            return str(parent)
    
    # 3. 使用默认路径
    return os.path.expanduser('~/.openclaw/workspace')

def init(workspace=None):
    """初始化决策日志系统"""
    global DECISIONS_DIR, INDEX_FILE, WORKSPACE
    
    if workspace is None:
        workspace = detect_workspace()
    
    WORKSPACE = workspace
    DECISIONS_DIR = Path(workspace) / 'life' / 'decisions'
    DECISIONS_DIR.mkdir(parents=True, exist_ok=True)
    
    INDEX_FILE = DECISIONS_DIR / 'index.json'
    
    if not INDEX_FILE.exists():
        INDEX_FILE.write_text(json.dumps({'decisions': [], 'stats': {}}, indent=2))

def create_decision(title, context, options, selected, reason, 
                   expected_outcome=None, tags=None, decision_type='general'):
    """
    创建决策记录
    
    Args:
        title: 决策标题
        context: 决策背景
        options: 选项列表
        selected: 选择的选项索引
        reason: 选择原因
        expected_outcome: 预期结果
        tags: 标签列表
        decision_type: 决策类型 (architecture/technical/process/general)
    """
    init()
    
    # 读取现有索引
    existing = json.loads(INDEX_FILE.read_text())
    
    # 生成决策ID - 基于已有数量
    date_str = datetime.now().strftime('%Y%m%d')
    today_decisions = [d for d in existing['decisions'] if d['id'].startswith(f'dec-{date_str}')]
    count = len(today_decisions)
    decision_id = f"dec-{date_str}-{count + 1:03d}"
    
    # 确保ID唯一
    existing_ids = [d['id'] for d in existing['decisions']]
    while decision_id in existing_ids:
        count += 1
        decision_id = f"dec-{date_str}-{count + 1:03d}"
    
    # 创建决策记录
    decision = {
        'id': decision_id,
        'title': title,
        'type': decision_type,
        'timestamp': datetime.now().isoformat(),
        'context': context,
        'options': options,
        'selected': selected,
        'selected_option': options[selected] if selected < len(options) else None,
        'reason': reason,
        'expected_outcome': expected_outcome,
        'tags': tags or [],
        'status': 'pending'  # pending/verified/failed
    }
    
    # 保存决策文件
    decision_file = DECISIONS_DIR / f"{decision_id}.json"
    decision_file.write_text(json.dumps(decision, indent=2, ensure_ascii=False))
    
    # 更新索引
    existing['decisions'].append({
        'id': decision_id,
        'title': title,
        'type': decision_type,
        'date': datetime.now().strftime('%Y-%m-%d'),
        'file': str(decision_file.name)
    })
    
    # 更新统计
    if decision_type not in existing['stats']:
        existing['stats'][decision_type] = 0
    existing['stats'][decision_type] += 1
    
    INDEX_FILE.write_text(json.dumps(existing, indent=2, ensure_ascii=False))
    
    print(f"✅ 决策已记录: {decision_id}")
    print(f"   标题: {title}")
    print(f"   选择: {options[selected]}")
    print(f"   原因: {reason}")
    
    return decision_id

def list_decisions(limit=10, decision_type=None):
    """列出最近的决策"""
    init()
    
    existing = json.loads(INDEX_FILE.read_text())
    decisions = existing['decisions']
    
    if decision_type:
        decisions = [d for d in decisions if d['type'] == decision_type]
    
    return decisions[-limit:]

def get_decision(decision_id):
    """获取决策详情"""
    init()
    
    decision_file = DECISIONS_DIR / f"{decision_id}.json"
    if not decision_file.exists():
        return None
    
    return json.loads(decision_file.read_text())

def verify_decision(decision_id, outcome, actual_result):
    """验证决策结果"""
    init()
    
    decision = get_decision(decision_id)
    if not decision:
        print(f"❌ 决策不存在: {decision_id}")
        return False
    
    decision['status'] = outcome  # verified/failed
    decision['actual_result'] = actual_result
    decision['verified_at'] = datetime.now().isoformat()
    
    decision_file = DECISIONS_DIR / f"{decision_id}.json"
    decision_file.write_text(json.dumps(decision, indent=2, ensure_ascii=False))
    
    print(f"✅ 决策已验证: {decision_id}")
    print(f"   结果: {outcome}")
    return True

def main():
    """命令行入口"""
    import sys
    
    if len(sys.argv) < 2:
        print("用法:")
        print("  创建决策: decision_logger.py create <title> <context> <options_json> <selected> <reason>")
        print("  列出决策: decision_logger.py list [limit]")
        print("  查看决策: decision_logger.py get <decision_id>")
        print("  验证决策: decision_logger.py verify <decision_id> <outcome> <result>")
        return
    
    command = sys.argv[1]
    
    if command == 'list':
        limit = int(sys.argv[2]) if len(sys.argv) > 2 else 10
        decisions = list_decisions(limit)
        for d in decisions:
            print(f"- [{d['id']}] {d['title']} ({d['date']})")
    
    elif command == 'get':
        if len(sys.argv) < 3:
            print("请提供决策ID")
            return
        decision = get_decision(sys.argv[2])
        if decision:
            print(json.dumps(decision, indent=2, ensure_ascii=False))
        else:
            print("决策不存在")
    
    elif command == 'create':
        if len(sys.argv) < 7:
            print("参数不足")
            return
        create_decision(
            title=sys.argv[2],
            context=sys.argv[3],
            options=json.loads(sys.argv[4]),
            selected=int(sys.argv[5]),
            reason=sys.argv[6]
        )
    
    elif command == 'verify':
        if len(sys.argv) < 5:
            print("参数不足")
            return
        verify_decision(sys.argv[2], sys.argv[3], sys.argv[4])

if __name__ == '__main__':
    main()